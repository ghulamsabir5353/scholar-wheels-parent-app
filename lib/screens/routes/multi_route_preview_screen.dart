import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:dio/dio.dart';

class RouteOption {
  final String id;
  final List<LatLng> points;
  final String summary;
  final String distanceText;
  final String durationText;
  final int distanceMeters;
  final int durationSeconds;

  RouteOption({
    required this.id,
    required this.points,
    required this.summary,
    required this.distanceText,
    required this.durationText,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class MultiRoutePreviewScreen extends StatefulWidget {
  final LatLng start;
  final LatLng end;
  final LatLng? liveLocation;
  final List<RouteOption> initialRoutes;
  final String googleApiKey;
  final Future<List<RouteOption>> Function(LatLng start, LatLng end)?
  directionsFetcher;
  final void Function(RouteOption selected)? onRouteSelected;

  const MultiRoutePreviewScreen({
    super.key,
    required this.start,
    required this.end,
    required this.googleApiKey,
    required this.initialRoutes,
    this.liveLocation,
    this.directionsFetcher,
    this.onRouteSelected,
  });

  @override
  State<MultiRoutePreviewScreen> createState() =>
      _MultiRoutePreviewScreenState();
}

class _MultiRoutePreviewScreenState extends State<MultiRoutePreviewScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final Map<MarkerId, Marker> _markers = {};
  String? _selectedRouteId;
  DateTime _lastReroute = DateTime.fromMillisecondsSinceEpoch(0);
  bool _isRerouting = false;
  bool _isLoadingRoutes = false;
  static const _rerouteThrottle = Duration(seconds: 8);
  static const _deviationThresholdMeters = 40.0;

  static const _mapStyle = '''
  {
    "featureType": "poi",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "transit",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "administrative",
    "stylers": [{ "visibility": "off" }]
  }
  ''';

  List<RouteOption> _routes = [];

  @override
  void initState() {
    super.initState();
    _initRoutes();
  }

  @override
  void didUpdateWidget(covariant MultiRoutePreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.liveLocation != oldWidget.liveLocation &&
        widget.liveLocation != null) {
      _updateLiveMarker(widget.liveLocation!);
      _checkDeviationAndMaybeReroute(widget.liveLocation!);
    }
  }

  void _buildMarkers() {
    _markers.clear();
    _markers[const MarkerId('start')] = Marker(
      markerId: const MarkerId('start'),
      position: widget.start,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'Start'),
      zIndex: 2,
    );
    _markers[const MarkerId('end')] = Marker(
      markerId: const MarkerId('end'),
      position: widget.end,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Destination'),
      zIndex: 2,
    );
    if (widget.liveLocation != null) {
      _markers[const MarkerId('live')] = Marker(
        markerId: const MarkerId('live'),
        position: widget.liveLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        zIndex: 3,
        flat: true,
      );
    }
    setState(() {});
  }

  void _buildPolylines() {
    _polylines.clear();
    for (final route in _routes) {
      final isSelected = route.id == _selectedRouteId;
      _polylines[PolylineId(route.id)] = Polyline(
        polylineId: PolylineId(route.id),
        points: route.points,
        color: isSelected ? Colors.blue : Colors.grey,
        width: isSelected ? 6 : 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: const [],
      );
    }
    setState(() {});
  }

  Future<void> _fitToAllRoutes() async {
    if (_routes.isEmpty) return;
    final controller = await _mapController.future;
    final allPoints = <LatLng>[];
    for (final r in _routes) {
      allPoints.addAll(r.points);
    }
    if (allPoints.isEmpty) return;
    final bounds = _boundsFor(allPoints);
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  LatLngBounds _boundsFor(List<LatLng> pts) {
    double? minLat, maxLat, minLng, maxLng;
    for (final p in pts) {
      minLat ??= p.latitude;
      maxLat ??= p.latitude;
      minLng ??= p.longitude;
      maxLng ??= p.longitude;
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  void _onRouteTap(RouteOption option) {
    _selectedRouteId = option.id;
    _buildPolylines();
    widget.onRouteSelected?.call(option);
    _animateToRoute(option);
    setState(() {});
  }

  Future<void> _animateToRoute(RouteOption option) async {
    final c = await _mapController.future;
    if (option.points.isEmpty) return;
    final bounds = _boundsFor(option.points);
    await c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _updateLiveMarker(LatLng pos) {
    _markers[const MarkerId('live')] = Marker(
      markerId: const MarkerId('live'),
      position: pos,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      zIndex: 3,
      flat: true,
    );
    setState(() {});
  }

  Future<void> _checkDeviationAndMaybeReroute(LatLng current) async {
    final selected = _routes.firstWhere(
      (r) => r.id == _selectedRouteId,
      orElse: () => _routes.first,
    );
    if (selected.points.isEmpty) return;

    final path = selected.points
        .map((p) => mt.LatLng(p.latitude, p.longitude))
        .toList(growable: false);
    final cur = mt.LatLng(current.latitude, current.longitude);
    final distanceMeters = _distanceToPath(cur, path);

    if (distanceMeters > _deviationThresholdMeters) {
      final now = DateTime.now();
      if (now.difference(_lastReroute) >= _rerouteThrottle && !_isRerouting) {
        _lastReroute = now;
        _rerouteFrom(current);
      }
    }
  }

  double _distanceToPath(mt.LatLng point, List<mt.LatLng> path) {
    if (path.length < 2) return double.infinity;
    double minDist = double.infinity;
    for (var i = 0; i < path.length - 1; i++) {
      final double d = mt.PolygonUtil.distanceToLine(
        point,
        path[i],
        path[i + 1],
      ).toDouble();
      if (d < minDist) minDist = d;
    }
    return minDist;
  }

  Future<void> _rerouteFrom(LatLng current) async {
    if (_isRerouting) return;
    setState(() => _isRerouting = true);
    try {
      final fetcher = widget.directionsFetcher ?? _fetchRoutesFromApi;
      _routes = await fetcher(current, widget.end);
      if (_routes.isNotEmpty) {
        _selectedRouteId = _routes.first.id;
        _buildPolylines();
        widget.onRouteSelected?.call(_routes.first);
      }
    } finally {
      if (mounted) setState(() => _isRerouting = false);
    }
  }

  Future<void> _initRoutes() async {
    setState(() => _isLoadingRoutes = true);
    try {
      if (widget.initialRoutes.isNotEmpty) {
        _routes = widget.initialRoutes;
      } else {
        _routes = await _fetchRoutesFromApi(widget.start, widget.end);
      }
      if (_routes.isNotEmpty) {
        _selectedRouteId = _routes.first.id;
      }
      _buildMarkers();
      _buildPolylines();
      await _fitToAllRoutes();
    } finally {
      if (mounted) setState(() => _isLoadingRoutes = false);
    }
  }

  Future<List<RouteOption>> _fetchRoutesFromApi(
    LatLng origin,
    LatLng dest,
  ) async {
    final dio = Dio();
    final resp = await dio.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${dest.latitude},${dest.longitude}',
        'key': widget.googleApiKey,
        'mode': 'driving',
        'alternatives': 'true',
        'traffic_model': 'best_guess',
        'departure_time': (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      },
    );
    final data = resp.data;
    if (data == null || data['routes'] == null) return [];
    final List routes = data['routes'] as List;
    final results = <RouteOption>[];
    for (var i = 0; i < routes.length; i++) {
      final r = routes[i] as Map<String, dynamic>;
      final overview = r['overview_polyline']?['points'] as String? ?? '';
      final points = _decodePolyline(overview);
      final legs = (r['legs'] as List?) ?? [];
      int distanceMeters = 0;
      int durationSeconds = 0;
      String distanceText = '';
      String durationText = '';
      if (legs.isNotEmpty) {
        final leg = legs.first as Map<String, dynamic>;
        distanceMeters = (leg['distance']?['value'] ?? 0) as int;
        durationSeconds = (leg['duration']?['value'] ?? 0) as int;
        distanceText = (leg['distance']?['text'] ?? '') as String;
        durationText = (leg['duration']?['text'] ?? '') as String;
      }
      results.add(
        RouteOption(
          id: 'route_$i',
          points: points,
          summary: (r['summary'] ?? 'Route ${i + 1}') as String,
          distanceText: distanceText,
          durationText: durationText,
          distanceMeters: distanceMeters,
          durationSeconds: durationSeconds,
        ),
      );
    }
    return results;
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

  @override
  Widget build(BuildContext context) {
    final selected = _routes.firstWhere(
      (r) => r.id == _selectedRouteId,
      orElse: () => _routes.isNotEmpty
          ? _routes.first
          : RouteOption(
              id: 'none',
              points: [],
              summary: '',
              distanceText: '',
              durationText: '',
              distanceMeters: 0,
              durationSeconds: 0,
            ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.start,
                zoom: 13,
              ),
              mapType: MapType.normal,
              trafficEnabled: true,
              indoorViewEnabled: false,
              buildingsEnabled: false,
              myLocationEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              markers: _markers.values.toSet(),
              polylines: _polylines.values.toSet(),
              onMapCreated: (c) async {
                _mapController.complete(c);
                await c.setMapStyle('[$_mapStyle]');
                await _fitToAllRoutes();
              },
              onCameraMoveStarted: () => {},
            ),

            if (_isLoadingRoutes)
              const Positioned(
                top: 12,
                left: 16,
                child: Chip(
                  label: Text(
                    'Loading routes...',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),

            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.route, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selected.summary.isNotEmpty
                              ? selected.summary
                              : 'Route preview',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selected.durationText.isNotEmpty
                            ? selected.durationText
                            : 'ETA',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isRerouting)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Rerouting...',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final route = _routes[index];
                          final isSelected = route.id == _selectedRouteId;
                          return GestureDetector(
                            onTap: () => _onRouteTap(route),
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    route.summary.isNotEmpty
                                        ? route.summary
                                        : 'Route ${index + 1}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    route.durationText.isNotEmpty
                                        ? route.durationText
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    route.distanceText.isNotEmpty
                                        ? route.distanceText
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Select'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: _routes.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
