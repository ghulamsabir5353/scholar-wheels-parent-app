import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/models/location_data_model.dart';

class LocationAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(LocationData locationData)? onLocationSelected;

  const LocationAutocompleteField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.onLocationSelected,
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final Dio _dio = Dio();
  List<PlacePrediction> _predictions = [];
  bool _showSuggestions = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _textFieldKey = GlobalKey();
  Timer? _debounceTimer;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);
    _focusNode?.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode?.removeListener(_onFocusChanged);
    _focusNode?.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode!.hasFocus) {
      // Delay to allow tap on suggestion
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _removeOverlay();
        }
      });
    }
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      setState(() {
        _predictions = [];
        _showSuggestions = false;
      });
      _removeOverlay();
      return;
    }

    if (text.length < 2) {
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        _searchPlaces(text);
      }
    });
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) return;

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': AppConstants.googlePlacesApiKey,
          'components': 'country:za',
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final status = response.data['status'];
          if (status == 'OK' && response.data['predictions'] != null) {
            final predictions = (response.data['predictions'] as List)
                .map((json) => PlacePrediction.fromJson(json))
                .toList();

            setState(() {
              _predictions = predictions;
              _showSuggestions = predictions.isNotEmpty;
            });

            if (_showSuggestions && _focusNode!.hasFocus) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showOverlay();
                }
              });
            } else {
              _removeOverlay();
            }
          } else {
            setState(() {
              _predictions = [];
              _showSuggestions = false;
            });
            _removeOverlay();
          }
        } else {
          setState(() {
            _predictions = [];
            _showSuggestions = false;
          });
          _removeOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _predictions = [];
          _showSuggestions = false;
        });
        _removeOverlay();
      }
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': AppConstants.googlePlacesApiKey,
          'fields': 'name,formatted_address,geometry',
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final result = response.data['result'];
        final name = result['name'] ?? result['formatted_address'] ?? '';
        final geometry = result['geometry'];
        final location = geometry['location'];
        final lat = location['lat']?.toDouble() ?? 0.0;
        final lng = location['lng']?.toDouble() ?? 0.0;

        if (mounted) {
          widget.controller.text = name;
          _focusNode?.unfocus();
          _removeOverlay();

          if (widget.onLocationSelected != null) {
            final locationData = LocationData(
              placeId: placeId,
              description: name,
              coordinates: Coordinates(
                type: "Point",
                coordinates: [lng, lat], // [lng, lat] format
              ),
            );
            widget.onLocationSelected!(locationData);
          }
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _showOverlay() {
    if (!mounted || !_focusNode!.hasFocus || _predictions.isEmpty) return;

    _removeOverlay();

    final RenderBox? renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.textFieldBorderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _predictions.length > 5 ? 5 : _predictions.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: AppColor.textFieldBorderColor),
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return InkWell(
                  onTap: () {
                    _getPlaceDetails(prediction.placeId);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20.w,
                          color: AppColor.primary,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            prediction.description,
                            style: poppinFonts(
                              fontSize: sm,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: poppinFonts(
            color: Color(0xff212529),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: 70.h,
          child: Builder(
            builder: (context) {
              final textField = TextFormField(
                key: _textFieldKey,
                controller: widget.controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      'assets/images/svg/location.svg',
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xffADA4A5),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: AppColor.appColorWhite,
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.textFieldBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.textFieldBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.textFieldBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: widget.validator,
              );

              return textField;
            },
          ),
        ),
      ],
    );
  }
}

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
    );
  }
}
