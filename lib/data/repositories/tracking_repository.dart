import 'dart:async';

import 'package:live_tracking_app/core/services/local_data_service.dart';
import 'package:live_tracking_app/core/services/realtime_service.dart';
import 'package:live_tracking_app/core/utils/location.utils.dart';
import 'package:live_tracking_app/data/models/location_model.dart';

class TrackingRepository {
  final RealtimeService _realtimeService;
  final LocationUtils _locationUtils;
  final LocalDataService _localDataService;
  StreamSubscription? _positionSubscription;

  TrackingRepository(
    this._realtimeService,
    this._locationUtils,
    this._localDataService,
  );

  void startTracking() {
    _positionSubscription =
        _locationUtils.getPositionStream().listen((position) {
      final location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp ?? DateTime.now(),
      );
      try {
        _realtimeService.addLocation(location);
      } catch (e) {
        print('Error sending location: $e');
        _localDataService.addLocation(location);
      }
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
  }

  Future<void> retry() async {
    final locations = _localDataService.getAllLocations();
    for (final location in locations) {
      try {
        await _realtimeService.addLocation(location);
      } catch (e) {
        print('Error retrying location: $e');
        return;
      }
    }
    await _localDataService.clearLocations();
  }
}
