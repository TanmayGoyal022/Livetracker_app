import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'firebase_service.dart';

class TrackingService {
  StreamSubscription<Position>? _positionStream;
  final FirebaseService _firestore = FirebaseService();

  void startTracking(Function(Position) onLocationUpdate) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // only update if user moves >5 meters
          ),
        ).listen((position) async {
          onLocationUpdate(position); // update map
          await _firestore.storeLocation(
            position.latitude,
            position.longitude,
            DateTime.now(),
          ); // save to Firestore
        });
  }

  void stopTracking() {
    _positionStream?.cancel();
  }
}
