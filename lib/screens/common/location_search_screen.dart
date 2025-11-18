import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/models/location_data_model.dart';

class LocationSearchScreen extends StatefulWidget {
  static const route = '/location-search-screen';
  final String? initialValue;
  final String hintText;

  const LocationSearchScreen({
    super.key,
    this.initialValue,
    this.hintText = 'Search for a location...',
  });

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Dio _dio = Dio();
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialValue ?? '';
    _searchController.addListener(_onTextChanged);
    // Auto focus the text field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      // Move cursor to end if there's initial value
      if (_searchController.text.isNotEmpty) {
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _searchController.text;
    if (text.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      return;
    }

    if (text.length < 2) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
          // 'components': 'country:za',
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
              _isLoading = false;
            });
          } else {
            setState(() {
              _predictions = [];
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _predictions = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getPlaceDetails(String placeId, String description) async {
    try {
      setState(() {
        _isLoading = true;
      });

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
        // final name =
        //     result['formatted_address'] ?? result['name'] ?? description;
        final geometry = result['geometry'];
        final location = geometry['location'];
        final lat = location['lat']?.toDouble() ?? 0.0;
        final lng = location['lng']?.toDouble() ?? 0.0;

        if (mounted) {
          // Use the original description that user selected (not formatted_address)
          // This ensures the displayed address matches what the user chose
          final locationData = LocationData(
            placeId: placeId,
            description:
                description, // Use the description from autocomplete (what user selected)
            coordinates: Coordinates(
              type: "Point",
              coordinates: [lng, lat], // [lng, lat] format
            ),
          );

          // Return the selected location data
          Get.back(result: locationData);
        }
      } else {
        // If details fetch fails, still return with description
        if (mounted) {
          final locationData = LocationData(
            placeId: placeId,
            description: description,
            coordinates: Coordinates(type: "Point", coordinates: [0.0, 0.0]),
          );
          Get.back(result: locationData);
        }
      }
    } catch (e) {
      // If error, still return with description
      if (mounted) {
        final locationData = LocationData(
          placeId: placeId,
          description: description,
          coordinates: Coordinates(type: "Point", coordinates: [0.0, 0.0]),
        );
        Get.back(result: locationData);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search Location',
          style: poppinFonts(
            fontSize: lg,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Text Field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.appColorWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColor.textFieldBorderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: poppinFonts(
                    fontSize: sm,
                    color: AppColor.bgGray979797,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      'assets/images/svg/search.svg',
                      width: 20.w,
                      height: 20.w,
                      colorFilter: ColorFilter.mode(
                        AppColor.textLightBlackColor4A4A4A,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  suffixIcon: _isLoading
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.primary,
                              ),
                            ),
                          ),
                        )
                      : _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20.w,
                            color: AppColor.textLightBlackColor4A4A4A,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _predictions = [];
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ),
          ),

          // Suggestions List
          Expanded(
            child: _predictions.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64.w,
                          color: AppColor.bgGray979797.withOpacity(0.5),
                        ),
                        SpaceHelper(h: 16.h),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Start typing to search for locations'
                              : 'No results found',
                          style: poppinFonts(
                            fontSize: sm,
                            color: AppColor.bgGray979797,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _predictions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: AppColor.textFieldBorderColor,
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                    itemBuilder: (context, index) {
                      final prediction = _predictions[index];
                      return InkWell(
                        onTap: () {
                          _getPlaceDetails(
                            prediction.placeId,
                            prediction.description,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColor.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 24.w,
                                  color: AppColor.primary,
                                ),
                              ),
                              SpaceHelper(w: 12.w),
                              Expanded(
                                child: Text(
                                  prediction.description,
                                  style: poppinFonts(
                                    fontSize: sm,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.w,
                                color: AppColor.bgGray979797,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
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
