import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/models/location_data_model.dart';

class RouteMapWidget extends StatefulWidget {
  final LocationData? pickupLocation;
  final LocationData? dropOffLocation;
  final LatLng? driverLocation;
  final List<LatLng>? coveredPath;
  final List<LatLng>? remainingPath;
  final List<LocationData>? pickupLocations; // All child pickup locations
  final double height;
  final double width;

  /// When false, hides the default zoom +/- buttons; pinch-to-zoom still works.
  final bool zoomControlsEnabled;

  const RouteMapWidget({
    super.key,
    required this.pickupLocation,
    required this.dropOffLocation,
    this.driverLocation,
    this.coveredPath,
    this.remainingPath,
    this.pickupLocations, // All child pickup locations
    this.height = 200,
    this.width = double.infinity,
    this.zoomControlsEnabled = false,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final Completer<int> _mapIdCompleter = Completer<int>();
  List<LatLng> _routePolylinePoints = [];
  bool _isFetchingRoute = false;
  BitmapDescriptor? _driverIcon;
  Timer? _autoRecenterTimer;
  LatLng? _lastRecenterPosition;
  bool _hasInitializedCamera = false;
  bool _isMapReady = false;
  Timer? _markerUpdateDebounce;
  bool _isUpdatingMarkers = false;

  // Hide all third‑party place labels/icons so only our markers are visible.
  // JSON must not contain comments - they cause MapStyleException on iOS.
  static const _mapStyle = '''
  [
    { "featureType": "poi", "stylers": [{ "visibility": "off" }] },
    { "featureType": "poi.business", "stylers": [{ "visibility": "off" }] },
    { "featureType": "transit", "stylers": [{ "visibility": "off" }] },
    { "featureType": "administrative", "elementType": "labels", "stylers": [{ "visibility": "off" }] },
    { "featureType": "water", "elementType": "labels", "stylers": [{ "visibility": "off" }] }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _loadDriverIcon();
    _initializeMap();
    _loadRoutePolyline();
  }

  @override
  void didUpdateWidget(covariant RouteMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final driverLocChanged = oldWidget.driverLocation != widget.driverLocation;

    // Handle driver location updates separately (more frequent, only update driver marker)
    if (driverLocChanged && _isMapReady) {
      _updateDriverMarker();
      _scheduleAutoRecenter();
      return; // Don't rebuild everything for driver location updates
    }

    // For other changes, rebuild everything
    if (oldWidget.coveredPath != widget.coveredPath ||
        oldWidget.remainingPath != widget.remainingPath ||
        oldWidget.pickupLocation != widget.pickupLocation ||
        oldWidget.dropOffLocation != widget.dropOffLocation ||
        oldWidget.pickupLocations != widget.pickupLocations) {
      _initializeMap();
      _loadRoutePolyline();
    }
  }

  /// Update only the driver marker position (more efficient than rebuilding all markers)
  void _updateDriverMarker() {
    if (!_isMapReady || _mapController == null || _isUpdatingMarkers) return;

    // Cancel any pending marker updates
    _markerUpdateDebounce?.cancel();

    // Debounce marker updates more aggressively to avoid platform channel errors
    // Increased to 500ms to give Animarker time to sync
    _markerUpdateDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || !_isMapReady || _isUpdatingMarkers) return;

      try {
        _isUpdatingMarkers = true;
        final markers = Set<Marker>.from(_markers);

        // Remove old driver marker
        markers.removeWhere((m) => m.markerId.value == 'driver');

        // Add updated driver marker
        if (widget.driverLocation != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('driver'),
              position: widget.driverLocation!,
              icon:
                  _driverIcon ??
                  BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
              infoWindow: const InfoWindow(
                title: 'Driver',
                snippet: 'Current position',
              ),
              flat: true,
              zIndex: 100,
            ),
          );
        }

        if (mounted) {
          setState(() {
            _markers = markers;
          });
        }
      } catch (e) {
        // Silently handle errors - map might not be ready
        debugPrint('Error updating driver marker: $e');
      } finally {
        // Reset flag after a delay to allow Animarker to sync
        Future.delayed(const Duration(milliseconds: 200), () {
          _isUpdatingMarkers = false;
        });
      }
    });
  }

  void _initializeMap() {
    if (widget.pickupLocation == null && widget.dropOffLocation == null) {
      return;
    }

    final markers = <Marker>{};
    final polylines = <Polyline>{};

    if (widget.driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: widget.driverLocation!,
          icon:
              _driverIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(
            title: 'Driver',
            snippet: 'Current position',
          ),
          flat: true,
          zIndex: 100,
        ),
      );
    }

    // Pickup markers - show all child pickup locations
    if (widget.pickupLocations != null && widget.pickupLocations!.isNotEmpty) {
      for (var i = 0; i < widget.pickupLocations!.length; i++) {
        final pickupLoc = widget.pickupLocations![i];
        final pickupLat = pickupLoc.coordinates.latitude;
        final pickupLng = pickupLoc.coordinates.longitude;

        if (pickupLat != 0.0 && pickupLng != 0.0) {
          markers.add(
            Marker(
              markerId: MarkerId('pickup_$i'),
              position: LatLng(pickupLat, pickupLng),
              infoWindow: InfoWindow(
                title: 'Pickup ${i + 1}',
                snippet: pickupLoc.description,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
        }
      }
    } else if (widget.pickupLocation != null) {
      // Fallback to single pickup location
      final pickupLat = widget.pickupLocation!.coordinates.latitude;
      final pickupLng = widget.pickupLocation!.coordinates.longitude;

      if (pickupLat != 0.0 && pickupLng != 0.0) {
        markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(pickupLat, pickupLng),
            infoWindow: InfoWindow(
              title: 'Pickup',
              snippet: widget.pickupLocation!.description,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }
    }

    // Drop-off marker
    if (widget.dropOffLocation != null) {
      final dropOffLat = widget.dropOffLocation!.coordinates.latitude;
      final dropOffLng = widget.dropOffLocation!.coordinates.longitude;

      if (dropOffLat != 0.0 && dropOffLng != 0.0) {
        markers.add(
          Marker(
            markerId: const MarkerId('dropoff'),
            position: LatLng(dropOffLat, dropOffLng),
            infoWindow: InfoWindow(
              title: 'Drop-off',
              snippet: widget.dropOffLocation!.description,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      }
    }

    // Covered path (gray) if provided
    if (widget.coveredPath != null && widget.coveredPath!.length > 1) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('covered'),
          points: widget.coveredPath!,
          color: Colors.grey,
          width: 6,
          patterns: [PatternItem.dash(12), PatternItem.gap(6)],
        ),
      );
    }

    // Driving route from Google Directions (blue, solid) if available.
    if (_routePolylinePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('google_route'),
          points: _routePolylinePoints,
          color: AppColor.primary,
          width: 8,
        ),
      );
    }
    // Remaining path (blue) fallback if directions are not available.
    else if (widget.remainingPath != null && widget.remainingPath!.length > 1) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('remaining'),
          points: widget.remainingPath!,
          color: AppColor.blueText,
          width: 6,
        ),
      );
    } else if (widget.pickupLocation != null &&
        widget.dropOffLocation != null &&
        widget.pickupLocation!.coordinates.latitude != 0.0 &&
        widget.pickupLocation!.coordinates.longitude != 0.0 &&
        widget.dropOffLocation!.coordinates.latitude != 0.0 &&
        widget.dropOffLocation!.coordinates.longitude != 0.0) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            LatLng(
              widget.pickupLocation!.coordinates.latitude,
              widget.pickupLocation!.coordinates.longitude,
            ),
            LatLng(
              widget.dropOffLocation!.coordinates.latitude,
              widget.dropOffLocation!.coordinates.longitude,
            ),
          ],
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    // Only update markers if not currently updating to avoid platform channel conflicts
    if (!_isUpdatingMarkers) {
      try {
        setState(() {
          _markers = markers;
          _polylines = polylines;
        });
      } catch (e) {
        debugPrint('Error setting markers in _initializeMap: $e');
        // Retry after a delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !_isUpdatingMarkers) {
            try {
              setState(() {
                _markers = markers;
                _polylines = polylines;
              });
            } catch (_) {
              // Ignore retry errors
            }
          }
        });
      }
    }

    // Note: Bounds fitting will happen in onMapCreated callback
    // after the map controller is available
  }

  Future<void> _loadDriverIcon() async {
    await _createIconFromPng('assets/images/png/bus-stop.png', 110);
  }

  Future<void> _createIconFromPng(String assetPath, double size) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: size.toInt(),
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) throw Exception('ByteData null after resize');
      final Uint8List resizedBytes = byteData.buffer.asUint8List();

      if (mounted) {
        setState(() {
          _driverIcon = BitmapDescriptor.fromBytes(resizedBytes);
        });
        _initializeMap(); // refresh markers with custom icon
      }
    } catch (e) {
      // Fallback: try direct bytes (no resize)
      try {
        final ByteData data = await rootBundle.load(assetPath);
        final Uint8List bytes = data.buffer.asUint8List();
        if (mounted) {
          setState(() {
            _driverIcon = BitmapDescriptor.fromBytes(bytes);
          });
          _initializeMap(); // refresh markers with custom icon
        }
      } catch (_) {
        // keep default marker if everything fails
      }
    }
  }

  void _zoomCamera(double delta) {
    if (_mapController == null) return;
    _mapController?.animateCamera(CameraUpdate.zoomBy(delta));
  }

  void _recenterCamera() {
    if (_mapController == null) return;

    // Prioritize driver location if available
    if (widget.driverLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(widget.driverLocation!, 16),
      );
      _lastRecenterPosition = widget.driverLocation;
      return;
    }

    if (_markers.length >= 2) {
      _fitBounds();
      return;
    }

    if (_markers.isNotEmpty) {
      final marker = _markers.first;
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(marker.position, 16),
      );
      return;
    }

    _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_getCenter(), 16));
  }

  void _scheduleAutoRecenter() {
    _autoRecenterTimer?.cancel();
    // Use 2 seconds delay for more responsive following
    _autoRecenterTimer = Timer(const Duration(seconds: 2), () {
      if (widget.driverLocation != null && _mapController != null) {
        // Check if driver moved significantly (more than ~50 meters)
        final shouldRecenter =
            _lastRecenterPosition == null ||
            _hasDriverMovedSignificantly(
              _lastRecenterPosition!,
              widget.driverLocation!,
            );

        if (shouldRecenter) {
          // Focus on driver with zoom level 16 (good for following moving vehicle)
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(widget.driverLocation!, 16),
          );
          _lastRecenterPosition = widget.driverLocation;
        }
      }
    });
  }

  /// Check if driver has moved significantly (more than ~50 meters)
  bool _hasDriverMovedSignificantly(LatLng oldPos, LatLng newPos) {
    // Simple distance calculation (Haversine approximation)
    const double threshold = 0.0005; // ~50 meters
    final latDiff = (oldPos.latitude - newPos.latitude).abs();
    final lngDiff = (oldPos.longitude - newPos.longitude).abs();
    return latDiff > threshold || lngDiff > threshold;
  }

  Widget _controlButton({required IconData icon, required VoidCallback onTap}) {
    final double size = 42.w;
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: 22.sp, color: Colors.black87),
        ),
      ),
    );
  }

  Future<void> _loadRoutePolyline() async {
    if (widget.dropOffLocation == null ||
        (widget.driverLocation == null &&
            widget.pickupLocation == null &&
            (widget.pickupLocations == null ||
                widget.pickupLocations!.isEmpty))) {
      if (mounted) {
        setState(() {
          _routePolylinePoints = [];
          _isFetchingRoute = false;
        });
      }
      return;
    }

    // Origin: driver location or first pickup
    LatLng origin;
    if (widget.driverLocation != null) {
      origin = widget.driverLocation!;
    } else if (widget.pickupLocations != null &&
        widget.pickupLocations!.isNotEmpty) {
      origin = LatLng(
        widget.pickupLocations!.first.coordinates.latitude,
        widget.pickupLocations!.first.coordinates.longitude,
      );
    } else {
      origin = LatLng(
        widget.pickupLocation!.coordinates.latitude,
        widget.pickupLocation!.coordinates.longitude,
      );
    }

    // Destination: final dropoff location
    final destination = LatLng(
      widget.dropOffLocation!.coordinates.latitude,
      widget.dropOffLocation!.coordinates.longitude,
    );

    // Build waypoints: all pickup locations (excluding origin if it's a pickup)
    List<LatLng> waypoints = [];
    if (widget.pickupLocations != null && widget.pickupLocations!.isNotEmpty) {
      for (var pickupLoc in widget.pickupLocations!) {
        final waypoint = LatLng(
          pickupLoc.coordinates.latitude,
          pickupLoc.coordinates.longitude,
        );
        // Only add if it's different from origin (if origin is driver location)
        if (widget.driverLocation == null ||
            (waypoint.latitude != origin.latitude ||
                waypoint.longitude != origin.longitude)) {
          waypoints.add(waypoint);
        }
      }
    }

    try {
      if (mounted) {
        setState(() {
          _isFetchingRoute = true;
        });
      }

      // Build query parameters
      final queryParams = <String, dynamic>{
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'alternatives': 'false',
        'key': AppConstants.googlePlacesApiKey,
      };

      // Add waypoints if we have multiple stops
      if (waypoints.isNotEmpty) {
        // Format waypoints as: "lat1,lng1|lat2,lng2|lat3,lng3"
        final waypointStrings = waypoints.map((wp) {
          return '${wp.latitude},${wp.longitude}';
        }).toList();
        queryParams['waypoints'] = waypointStrings.join('|');
        queryParams['optimize'] = 'false'; // Keep original order
      }

      final resp = await Dio().get(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: queryParams,
      );

      final routes = resp.data?['routes'] as List?;
      List<LatLng> decoded = [];
      if (routes != null && routes.isNotEmpty) {
        final overview =
            routes.first['overview_polyline']?['points'] as String? ?? '';
        if (overview.isNotEmpty) {
          decoded = _decodePolyline(overview);
        }
      }

      if (mounted) {
        setState(() {
          _routePolylinePoints = decoded;
        });
        _initializeMap(); // rebuild polylines with the new route
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _routePolylinePoints = [];
        });
        _initializeMap(); // fall back to straight line if directions fail
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingRoute = false;
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final latD = lat / 1e5;
      final lngD = lng / 1e5;
      poly.add(LatLng(latD, lngD));
    }

    return poly;
  }

  void _fitBounds() {
    if (_mapController == null || _markers.length < 2) return;

    final positions = _markers.map((m) => m.position).toList();
    double minLat = positions[0].latitude;
    double maxLat = positions[0].latitude;
    double minLng = positions[0].longitude;
    double maxLng = positions[0].longitude;

    for (var pos in positions) {
      if (pos.latitude < minLat) minLat = pos.latitude;
      if (pos.latitude > maxLat) maxLat = pos.latitude;
      if (pos.longitude < minLng) minLng = pos.longitude;
      if (pos.longitude > maxLng) maxLng = pos.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Use animateCamera for smooth animation with proper padding
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120.h));
  }

  LatLng _getCenter() {
    // Prioritize driver location for initial camera position
    if (widget.driverLocation != null) {
      return widget.driverLocation!;
    }

    if (widget.pickupLocation != null &&
        widget.dropOffLocation != null &&
        widget.pickupLocation!.coordinates.latitude != 0.0 &&
        widget.pickupLocation!.coordinates.longitude != 0.0 &&
        widget.dropOffLocation!.coordinates.latitude != 0.0 &&
        widget.dropOffLocation!.coordinates.longitude != 0.0) {
      final pickupLat = widget.pickupLocation!.coordinates.latitude;
      final pickupLng = widget.pickupLocation!.coordinates.longitude;
      final dropOffLat = widget.dropOffLocation!.coordinates.latitude;
      final dropOffLng = widget.dropOffLocation!.coordinates.longitude;

      return LatLng((pickupLat + dropOffLat) / 2, (pickupLng + dropOffLng) / 2);
    } else if (widget.pickupLocation != null &&
        widget.pickupLocation!.coordinates.latitude != 0.0 &&
        widget.pickupLocation!.coordinates.longitude != 0.0) {
      return LatLng(
        widget.pickupLocation!.coordinates.latitude,
        widget.pickupLocation!.coordinates.longitude,
      );
    } else if (widget.dropOffLocation != null &&
        widget.dropOffLocation!.coordinates.latitude != 0.0 &&
        widget.dropOffLocation!.coordinates.longitude != 0.0) {
      return LatLng(
        widget.dropOffLocation!.coordinates.latitude,
        widget.dropOffLocation!.coordinates.longitude,
      );
    }

    // Default to South Africa center
    return const LatLng(-25.7479, 28.2293);
  }

  double _getInitialZoom() {
    // Use zoom 16 for driver location (good for following moving vehicle)
    if (widget.driverLocation != null) {
      return 16;
    }
    // Use zoom 13 for general view
    return 15;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pickupLocation == null && widget.dropOffLocation == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xffECF4E9),
          border: Border.all(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            'No location data available',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
          ),
        ),
      );
    }

    final map = GoogleMap(
      key: ValueKey('map_zoom_${widget.zoomControlsEnabled}'),
      initialCameraPosition: CameraPosition(
        target: _getCenter(),
        zoom: _getInitialZoom(),
      ),
      markers: _markers,
      polylines: _polylines,
      mapType: MapType.normal,
      trafficEnabled: true,
      buildingsEnabled: false,
      indoorViewEnabled: false,
      myLocationEnabled: false,
      compassEnabled: true,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      liteModeEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(1.0, 20.0),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if (!_mapIdCompleter.isCompleted) {
          _mapIdCompleter.complete(controller.mapId);
        }
        controller.setMapStyle(_mapStyle).catchError((_) {
          // If custom style fails (e.g. MapStyleException on iOS), use default map
        });

        // Mark map as ready after a longer delay to ensure platform channel is fully established
        // Animarker needs time to initialize its own channel connections
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _isMapReady = true;
            });
          }
        });

        // Immediately focus on driver location if available, otherwise fit bounds
        if (!_hasInitializedCamera) {
          _hasInitializedCamera = true;
          if (widget.driverLocation != null) {
            // Focus on driver immediately with zoom 16
            Future.delayed(const Duration(milliseconds: 100), () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(widget.driverLocation!, 16),
              );
              _lastRecenterPosition = widget.driverLocation;
            });
          } else if (_markers.length >= 2) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _fitBounds();
            });
          }
        }
      },
    );

    // If directions are still loading and no polyline is ready, show loader only.
    if (_isFetchingRoute && _routePolylinePoints.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xffECF4E9),
          border: Border.all(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColor.primary),
              SizedBox(height: 8.h),
              Text(
                'Fetching route...',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xffECF4E9),
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Animarker(
              mapId: _mapIdCompleter.future,
              duration: const Duration(milliseconds: 900),
              shouldAnimateCamera:
                  false, // Keep false - we handle camera manually
              markers: _markers,
              child: map,
            ),
          ),
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _controlButton(icon: Icons.my_location, onTap: _recenterCamera),
                if (widget.zoomControlsEnabled) ...[
                  SizedBox(height: 8.h),
                  _controlButton(icon: Icons.add, onTap: () => _zoomCamera(1)),
                  SizedBox(height: 8.h),
                  _controlButton(
                    icon: Icons.remove,
                    onTap: () => _zoomCamera(-1),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _autoRecenterTimer?.cancel();
    _markerUpdateDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
