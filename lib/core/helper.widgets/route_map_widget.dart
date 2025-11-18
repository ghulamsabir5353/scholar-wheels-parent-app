import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarwheels/models/location_data_model.dart';

class RouteMapWidget extends StatefulWidget {
  final LocationData? pickupLocation;
  final LocationData? dropOffLocation;
  final double height;
  final double width;

  const RouteMapWidget({
    super.key,
    required this.pickupLocation,
    required this.dropOffLocation,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    if (widget.pickupLocation == null && widget.dropOffLocation == null) {
      return;
    }

    final markers = <Marker>{};
    final polylines = <Polyline>{};

    // Pickup marker
    if (widget.pickupLocation != null) {
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

    // Polyline between pickup and dropoff
    if (widget.pickupLocation != null &&
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

    setState(() {
      _markers = markers;
      _polylines = polylines;
    });

    // Note: Bounds fitting will happen in onMapCreated callback
    // after the map controller is available
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
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120.h));
  }

  LatLng _getCenter() {
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

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xffECF4E9),
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _getCenter(), zoom: 13),
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          // Zoom controls (buttons)
          zoomControlsEnabled: true,
          // Pinch-to-zoom gestures: pinch fingers together = zoom in, spread apart = zoom out
          zoomGesturesEnabled: true,
          // Swipe/drag to move map
          scrollGesturesEnabled: true,
          // Tilt gesture
          tiltGesturesEnabled: true,
          // Rotate gesture
          rotateGesturesEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: true,
          liteModeEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Fit bounds after map is created - increased delay for smoother animation
            Future.delayed(const Duration(milliseconds: 800), () {
              if (_markers.length >= 2) {
                _fitBounds();
              } else if (_markers.isNotEmpty) {
                // If only one marker, center on it with smooth animation
                final marker = _markers.first;
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(marker.position, 15),
                );
              }
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
