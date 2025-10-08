import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  NetworkService() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      bool hasInternet = result != ConnectivityResult.none;
      if (_isConnected != hasInternet) {
        _isConnected = hasInternet;
        notifyListeners(); // Notify UI of change
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
