import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/models/dashboard_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/services/api_exception.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketAuthStatus {
  disconnected,
  connecting,
  connected,
  authenticating,
  authenticated,
  authError,
}

/// Live Tracking Controller for Parent App
/// This controller ONLY listens to socket events - it does NOT emit any events
/// Parents receive real-time updates from the driver app via socket events
class LiveTrackingController extends GetxController
    with WidgetsBindingObserver {
  final ApiService apiService = Get.find<ApiService>();

  // Current trip being tracked
  final Rx<NextTrip?> currentTrip = Rx<NextTrip?>(null);

  // Trip detail state (for fetching trip from API)
  final Rx<ViewState<NextTrip>> tripDetailState = Rx<ViewState<NextTrip>>(
    LoadingState(),
  );

  // Loading state
  final RxBool isLoading = false.obs;

  // Trip flow states
  final RxBool isTripJoined = false.obs;
  final RxBool isTripStarted = false.obs;
  final RxBool isTripEnded = false.obs;

  // Current driver location (from socket updates)
  // Format: { latitude: double, longitude: double, speed: double?, heading: double? }
  final Rx<Map<String, dynamic>?> driverLocation = Rx<Map<String, dynamic>?>(
    null,
  );

  // Socket connection
  IO.Socket? _socket;
  final Rx<SocketAuthStatus> socketAuthStatus = Rx<SocketAuthStatus>(
    SocketAuthStatus.disconnected,
  );
  bool _isAuthenticated = false;

  // Trip event callbacks (for UI to listen)
  Function(Map<String, dynamic>)? onJoinedTrip;
  Function(Map<String, dynamic>)? onTripStarted;
  Function(Map<String, dynamic>)? onTripEnded;
  Function(Map<String, dynamic>)? onLocationUpdated;
  Function(Map<String, dynamic>)? onChildStatusUpdated;
  Function(Map<String, dynamic>)? onSocketError;

  // Trip ID from arguments
  String? _tripId;
  String? _activeTripId;
  final RxList<LatLng> driverPath = <LatLng>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    // Reset states when controller is initialized
    _resetTripState(resetIds: true);

    _initializeFromArguments();
  }

  /// Public entry point to reconfigure for a new trip without creating
  /// another controller instance.
  void configureWithArguments(
    dynamic overrideArguments, {
    bool forceRefresh = false,
  }) {
    _initializeFromArguments(
      overrideArguments: overrideArguments,
      forceRefresh: forceRefresh,
    );
  }

  void _resetTripState({bool resetIds = false}) {
    isTripJoined.value = false;
    isTripStarted.value = false;
    isTripEnded.value = false;
    driverLocation.value = null;
    tripDetailState.value = LoadingState();
    driverPath.clear();
    if (resetIds) {
      _tripId = null;
      _activeTripId = null;
      currentTrip.value = null;
    }
  }

  /// Initialize from arguments (tripId)
  void _initializeFromArguments({
    dynamic overrideArguments,
    bool forceRefresh = false,
  }) {
    try {
      final arguments = overrideArguments ?? Get.arguments;
      String? nextTripId;
      NextTrip? incomingTrip;

      if (arguments is NextTrip) {
        incomingTrip = arguments;
        nextTripId = arguments.id ?? arguments.tripId;
      } else if (arguments is Map<String, dynamic>) {
        nextTripId =
            arguments['tripId']?.toString() ??
            arguments['_id']?.toString() ??
            arguments['id']?.toString();
      } else {
        tripDetailState.value = ErrorState('Invalid trip data');
        return;
      }

      if (_shouldSkipReload(nextTripId, forceRefresh)) {
        _joinTripIfAuthenticated();
        return;
      }

      _resetTripState(resetIds: false);
      _tripId = nextTripId;
      _activeTripId = nextTripId;

      if (_tripId == null || _tripId!.isEmpty) {
        tripDetailState.value = ErrorState('No trip ID available');
        return;
      }

      if (incomingTrip != null) {
        currentTrip.value = incomingTrip;
        tripDetailState.value = DataState(data: incomingTrip);
        _seedDriverPathFromTripIfEmpty(incomingTrip);
        _initializeSocket();
      } else {
        // Fetch trip details from API
        _fetchTripDetails();
      }
    } catch (e) {
      showApiError(e, logLabel: 'initializeFromArguments');
      tripDetailState.value = ErrorState(
        'Failed to initialize: ${e.toString()}',
      );
    }
  }

  bool _shouldSkipReload(String? nextTripId, bool forceRefresh) {
    return !forceRefresh &&
        nextTripId != null &&
        nextTripId.isNotEmpty &&
        _activeTripId != null &&
        _activeTripId == nextTripId &&
        currentTrip.value != null;
  }

  void _appendDriverPath(double? lat, double? lng) {
    if (lat == null || lng == null) return;
    try {
      driverPath.add(LatLng(lat, lng));
    } catch (_) {}
  }

  LatLng? getDropOffLatLng() {
    final trip = currentTrip.value;
    if (trip == null) return null;
    if (trip.assignedChildren?.isNotEmpty == true) {
      // Match live map: route ends at the last assigned child's drop-off
      final drop = trip.assignedChildren!.last.child?.dropOffAddress;
      if (drop != null &&
          drop.coordinates != null &&
          drop.coordinates!.coordinates != null &&
          drop.coordinates!.coordinates!.length >= 2) {
        final coords = drop.coordinates!.coordinates!;
        return LatLng(coords[1], coords[0]);
      }
    }
    return null;
  }

  /// Last known driver position from trip REST payload (before / without socket).
  LatLng? _driverLatLngFromTripSnapshot() {
    final p = currentTrip.value?.currentLocationLatLng;
    if (p == null) return null;
    return LatLng(p.latitude, p.longitude);
  }

  /// Seed path from dashboard/API so the map has a starting point until socket fires.
  void _seedDriverPathFromTripIfEmpty(NextTrip? trip) {
    final p = trip?.currentLocationLatLng;
    if (p == null) return;
    if (driverPath.isNotEmpty) return;
    driverPath.add(LatLng(p.latitude, p.longitude));
  }

  List<LatLng> buildRemainingPath() {
    LatLng? current = driverPath.isNotEmpty ? driverPath.last : null;
    if (current == null && driverLocation.value != null) {
      final map = driverLocation.value!;
      if (map['latitude'] != null && map['longitude'] != null) {
        current = LatLng(
          (map['latitude'] as num).toDouble(),
          (map['longitude'] as num).toDouble(),
        );
      }
    }
    current ??= _driverLatLngFromTripSnapshot();
    final drop = getDropOffLatLng();
    if (current == null || drop == null) return [];
    return [current, drop];
  }

  /// Fetch trip details using tripId
  Future<void> _fetchTripDetails() async {
    try {
      tripDetailState.value = LoadingState();
      final response = await apiService.fetchData('/trips/$_tripId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        log('Trip detail response: $data');

        NextTrip? trip;

        if (data is Map<String, dynamic>) {
          // Handle different response formats
          if (data['data'] is Map<String, dynamic>) {
            trip = NextTrip.fromJson(data['data'] as Map<String, dynamic>);
          } else if (data['_id'] != null || data['tripId'] != null) {
            trip = NextTrip.fromJson(data);
          }
        }

        if (trip != null) {
          currentTrip.value = trip;
          tripDetailState.value = DataState(data: trip);
          _seedDriverPathFromTripIfEmpty(trip);

          // Initialize socket after trip is loaded
          _initializeSocket();
        } else {
          tripDetailState.value = ErrorState(
            'Invalid trip detail format from server',
          );
        }
      } else {
        tripDetailState.value = ErrorState(
          response.data['message'] ?? 'Failed to load trip detail',
        );
      }
    } catch (e) {
      tripDetailState.value = ExceptionState(Exception(e.toString()));
      showApiError(e, logLabel: 'fetchTripDetails');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App resumed - rejoin trip if authenticated
      _joinTripIfAuthenticated();
    }
  }

  /// Get current trip
  NextTrip? get trip => currentTrip.value;

  /// Update trip data (for real-time updates)
  void updateTrip(NextTrip updatedTrip) {
    currentTrip.value = updatedTrip;
  }

  /// Initialize socket connection with WebSocket and polling fallback
  void _initializeSocket() {
    try {
      // If socket already exists and is connected, disconnect it first
      if (_socket != null) {
        log('Disconnecting existing socket before reinitializing...');
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
        _isAuthenticated = false;
      }

      log('Initializing socket connection for live tracking...');
      socketAuthStatus.value = SocketAuthStatus.connecting;

      // Create socket with WebSocket and polling fallback
      _socket = IO.io(
        AppConstants.baseUrlIp,
        IO.OptionBuilder()
            .setTransports([
              'websocket',
              'polling',
            ]) // WebSocket with polling fallback
            .enableReconnection() // Enable automatic reconnection
            .build(),
      );

      // Setup ALL event listeners BEFORE connecting
      _setupConnectionListeners();
      _setupAuthListeners();
      _setupTripEventListeners();

      // Use a small delay to ensure all listeners are fully registered
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_socket == null) {
          log('Socket was disposed, skipping connection');
          return;
        }

        // Check if socket is already connected
        if (_socket?.connected == true) {
          log(
            'Socket already connected before manual connect, handling connection...',
          );
          _handleSocketConnected();
        } else {
          // Now connect the socket (listeners are already set up)
          log('Connecting socket manually...');
          _socket?.connect();
        }
      });
    } catch (e) {
      log('Error initializing socket: $e');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
    }
  }

  /// Setup connection event listeners
  void _setupConnectionListeners() {
    // Remove existing listeners to avoid duplicates
    _socket?.off('connect');
    _socket?.off('disconnect');
    _socket?.off('reconnect');
    _socket?.off('reconnect_attempt');
    _socket?.off('reconnect_error');
    _socket?.off('reconnect_failed');
    _socket?.off('connect_error');
    _socket?.off('error');

    // Connection event handler
    _socket?.onConnect((_) {
      log('Socket connected successfully (onConnect callback)');
      _handleSocketConnected();
    });

    // Alternative 'connect' event listener
    // _socket?.on('connect', (_) {
    //   log('Socket connected event received (connect event)');
    //   _handleSocketConnected();
    // });

    // Handle socket reconnection
    _socket?.onReconnect((attemptNumber) {
      log('Socket reconnected after $attemptNumber attempts');
      socketAuthStatus.value = SocketAuthStatus.connected;
      // Re-authenticate and rejoin trip after reconnection
      _authenticate();
    });

    // Listen to reconnect attempt
    _socket?.on('reconnect_attempt', (attemptNumber) {
      log('Socket reconnection attempt #$attemptNumber');
      socketAuthStatus.value = SocketAuthStatus.connecting;
    });

    // Listen to reconnect errors
    _socket?.on('reconnect_error', (error) {
      log('Socket reconnection error: $error');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
    });

    // Listen to reconnect failed
    _socket?.on('reconnect_failed', (_) {
      log('Socket reconnection failed - all attempts exhausted');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
      _isAuthenticated = false;
    });

    _socket?.onDisconnect((_) {
      log('Socket disconnected');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
      _isAuthenticated = false;
    });

    _socket?.onConnectError((error) {
      log('Socket connection error: $error');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
      _isAuthenticated = false;
    });

    _socket?.onError((error) {
      log('Socket error: $error');
      socketAuthStatus.value = SocketAuthStatus.disconnected;
      _isAuthenticated = false;
    });
  }

  /// Handle socket connected event (centralized handler)
  void _handleSocketConnected() {
    // Prevent duplicate handling
    if (socketAuthStatus.value == SocketAuthStatus.connected) {
      log(
        'Socket already marked as connected, skipping duplicate connection handler',
      );
      return;
    }

    log('Handling socket connection...');
    socketAuthStatus.value = SocketAuthStatus.connected;
    // Immediately authenticate after connection
    _authenticate();
  }

  /// Setup authentication event listeners
  void _setupAuthListeners() {
    // Remove existing listeners to avoid duplicates
    _socket?.off('authenticated');
    _socket?.off('authError');

    // Listen for authenticated event (success)
    _socket?.on('authenticated', (data) {
      log('Socket authenticated successfully: $data');
      socketAuthStatus.value = SocketAuthStatus.authenticated;
      _isAuthenticated = true;

      // Join trip after authentication
      Future.delayed(const Duration(milliseconds: 100), () {
        _joinTripIfAuthenticated();
      });
    });

    // Listen for authError event (failure)
    _socket?.on('authError', (data) {
      log('Socket authentication error: $data');
      socketAuthStatus.value = SocketAuthStatus.authError;
      _isAuthenticated = false;
    });
  }

  /// Setup listeners for trip-related events (LISTEN ONLY - NO EMITTING)
  void _setupTripEventListeners() {
    // Remove existing listeners to avoid duplicates
    _socket?.off('joinedTrip');
    _socket?.off('tripStarted');
    _socket?.off('tripEnded');
    _socket?.off('locationUpdated');
    _socket?.off('childStatusUpdated');
    _socket?.off('childStatusUpdate');
    _socket?.off('driverLiveLocation');
    _socket?.off('error');

    // Listen for joinedTrip event (confirmation that trip was joined)
    _socket?.on('joinedTrip', (data) {
      log('Joined trip event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        isTripJoined.value = true;
        onJoinedTrip?.call(data);
      }
    });

    // Listen for tripStarted event (broadcast from driver)
    _socket?.on('tripStarted', (data) {
      log('Trip started event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        isTripStarted.value = true;
        onTripStarted?.call(data);

        // Update trip status if data contains trip info
        _updateTripFromEvent(data);
      }
    });

    // Listen for tripEnded event (broadcast from driver)
    _socket?.on('tripEnded', (data) {
      log('Trip ended event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        isTripEnded.value = true;
        isTripStarted.value = false;
        onTripEnded?.call(data);

        // Update trip status if data contains trip info
        _updateTripFromEvent(data);
      }
    });

    // Listen for locationUpdated event (driver location updates)
    _socket?.on('locationUpdated', (data) {
      log('Location updated event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        _handleLocationUpdate(data);
        onLocationUpdated?.call(data);
      }
    });

    // Listen for driverLiveLocation event (alternative event name)
    _socket?.on('driverLiveLocation', (data) {
      log('Driver live location event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        _handleLocationUpdate(data);
        onLocationUpdated?.call(data);
      }
    });

    // Listen for childStatusUpdated event (child pickup/dropoff status)
    _socket?.on('childStatusUpdated', (data) {
      log('Child status updated event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        _handleChildStatusUpdate(data);
        onChildStatusUpdated?.call(data);
      }
    });

    // Listen for childStatusUpdate event (alternative event name)
    _socket?.on('childStatusUpdate', (data) {
      log('Child status update event received: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        _handleChildStatusUpdate(data);
        onChildStatusUpdated?.call(data);
      }
    });

    // Listen for error event (general socket errors)
    _socket?.on('error', (data) {
      log('Socket error event: $data');
      if (_isAuthenticated && data is Map<String, dynamic>) {
        onSocketError?.call(data);
      }
    });
  }

  /// Handle location update from socket event
  void _handleLocationUpdate(Map<String, dynamic> data) {
    try {
      // Extract location data from event
      // Expected format from driver: { location: { coordinates: { coordinates: [lng, lat] } }, speed, heading }
      Map<String, dynamic>? locationData;

      if (data['location'] != null) {
        final location = data['location'];
        if (location is Map<String, dynamic>) {
          final coordinates = location['coordinates'];
          if (coordinates is Map<String, dynamic>) {
            final coords = coordinates['coordinates'];
            if (coords is List && coords.length >= 2) {
              // GeoJSON format: [longitude, latitude]
              final longitude = coords[0] as num;
              final latitude = coords[1] as num;

              locationData = {
                'latitude': latitude.toDouble(),
                'longitude': longitude.toDouble(),
                'speed': data['speed'] != null
                    ? (data['speed'] as num).toDouble()
                    : null,
                'heading': data['heading'] != null
                    ? (data['heading'] as num).toDouble()
                    : null,
                'timestamp': DateTime.now().toIso8601String(),
              };
            }
          }
        }
      } else if (data['latitude'] != null && data['longitude'] != null) {
        // Direct format: { latitude, longitude, speed?, heading? }
        locationData = {
          'latitude': (data['latitude'] as num).toDouble(),
          'longitude': (data['longitude'] as num).toDouble(),
          'speed': data['speed'] != null
              ? (data['speed'] as num).toDouble()
              : null,
          'heading': data['heading'] != null
              ? (data['heading'] as num).toDouble()
              : null,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      if (locationData != null) {
        driverLocation.value = locationData;
        _appendDriverPath(
          locationData['latitude'] as double?,
          locationData['longitude'] as double?,
        );
        log(
          'Driver location updated: ${locationData['latitude']}, ${locationData['longitude']}',
        );
      }
    } catch (e) {
      log('Error handling location update: $e');
    }
  }

  /// Handle child status update from socket event
  void _handleChildStatusUpdate(Map<String, dynamic> data) {
    try {
      final trip = currentTrip.value;
      if (trip == null) return;

      final childId = data['childId']?.toString();
      final type = data['type']?.toString(); // 'pickup' or 'dropoff'
      final status = data['status']?.toString();

      if (childId == null || type == null || status == null) {
        log(
          'Invalid child status update data: missing childId, type, or status',
        );
        return;
      }

      // Update local trip data
      final assignedChildren = trip.assignedChildren ?? [];
      for (var child in assignedChildren) {
        if (child.childId == childId || child.id == childId) {
          if (type == 'pickup') {
            child.pickupStatus = status;
          } else if (type == 'dropoff') {
            child.dropOffStatus = status;
          }
          // Trigger update
          currentTrip.value = trip;
          log('Updated child $childId $type status to $status');
          break;
        }
      }
    } catch (e) {
      log('Error handling child status update: $e');
    }
  }

  /// Update trip from event data
  void _updateTripFromEvent(Map<String, dynamic> data) {
    try {
      final trip = currentTrip.value;
      if (trip == null) return;

      // Update trip status if provided
      if (data['status'] != null) {
        trip.status = data['status'].toString();
      }

      // Update other trip fields if provided
      if (data['startTime'] != null) {
        // Handle startTime if needed
      }

      if (data['endTime'] != null) {
        // Handle endTime if needed
      }

      // Trigger update
      currentTrip.value = trip;
    } catch (e) {
      log('Error updating trip from event: $e');
    }
  }

  /// Authenticate socket connection with JWT token
  void _authenticate() {
    try {
      final token = BaseHelper.accessToken.value;
      if (token.isEmpty) {
        log('No access token available for authentication');
        socketAuthStatus.value = SocketAuthStatus.authError;
        return;
      }

      log('Authenticating socket with token...');
      socketAuthStatus.value = SocketAuthStatus.authenticating;

      // Emit authenticate event with JWT token
      _socket?.emit('authenticate', {'token': token});
    } catch (e) {
      log('Error during authentication: $e');
      socketAuthStatus.value = SocketAuthStatus.authError;
    }
  }

  /// Join trip - Emit joinTrip event with tripId
  /// This is called when:
  /// - Trip screen opens
  /// - App resumes
  /// - Socket reconnects
  void joinTrip() {
    final trip = currentTrip.value;
    if (trip == null) {
      log('No trip available to join');
      return;
    }

    final tripId = trip.id ?? trip.tripId;
    if (tripId == null || tripId.isEmpty) {
      log('Trip ID is null or empty');
      return;
    }

    if (!_isAuthenticated) {
      log('Socket not authenticated. Cannot join trip.');
      return;
    }

    log('Joining trip: $tripId');
    _socket?.emit('joinTrip', {'tripId': tripId});
  }

  /// Leave trip - Emit leaveTrip event with tripId
  /// This is called when:
  /// - Trip screen closes
  /// - Controller is disposed
  void leaveTrip() {
    final trip = currentTrip.value;
    if (trip == null) {
      log('No trip available to leave');
      return;
    }

    final tripId = trip.id ?? trip.tripId;
    if (tripId == null || tripId.isEmpty) {
      log('Trip ID is null or empty');
      return;
    }

    if (!_isAuthenticated) {
      log('Socket not authenticated. Cannot leave trip.');
      return;
    }

    log('Leaving trip: $tripId');
    _socket?.emit('leaveTrip', {'tripId': tripId});
    isTripJoined.value = false;
  }

  /// Join trip if authenticated (internal helper)
  void _joinTripIfAuthenticated() {
    if (!_isAuthenticated) {
      log('Cannot join trip: Socket not authenticated');
      return;
    }

    if (currentTrip.value == null) {
      log('Cannot join trip: No trip available');
      return;
    }

    log('Joining trip after authentication...');
    joinTrip();
  }

  /// Get socket authentication status
  bool get isSocketAuthenticated => _isAuthenticated;

  /// Get socket instance (for advanced usage)
  IO.Socket? get socket => _socket;

  /// Disconnect socket
  void disconnectSocket() {
    try {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
      _isAuthenticated = false;
      socketAuthStatus.value = SocketAuthStatus.disconnected;
      log('Socket disconnected');
    } catch (e) {
      log('Error disconnecting socket: $e');
    }
  }

  /// Refresh trip details from API
  Future<void> refreshTripDetails() async {
    if (_tripId != null && _tripId!.isNotEmpty) {
      await _fetchTripDetails();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // Leave trip before disconnecting
    if (isTripJoined.value) {
      leaveTrip();
    }
    disconnectSocket();
    super.onClose();
  }
}
