import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// When the map is shown, checks location permission and requests it via
/// permission_handler (system dialog) if not granted. Always shows [child] (the map).
class LocationPermissionMapGate extends StatefulWidget {
  final Widget child;

  const LocationPermissionMapGate({
    super.key,
    required this.child,
  });

  @override
  State<LocationPermissionMapGate> createState() =>
      _LocationPermissionMapGateState();
}

class _LocationPermissionMapGateState extends State<LocationPermissionMapGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndRequest());
  }

  Future<void> _checkAndRequest() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted && mounted) {
      await Permission.locationWhenInUse.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
