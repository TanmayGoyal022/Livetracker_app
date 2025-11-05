import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_tracking_app/core/services/realtime_service.dart';
import 'package:live_tracking_app/data/models/location_model.dart';
import 'package:live_tracking_app/data/models/visit_model.dart';

class VisitDetectionService {
  final RealtimeService _realtimeService = RealtimeService();

  // Constants for visit detection
  static const double _visitRadius = 50.0; // in meters
  static const int _visitDuration = 10; // in minutes

  Future<void> detectAndSaveVisits() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';

    final locationsSnapshot = await FirebaseFirestore.instance
        .collection('tracks')
        .doc(user.uid)
        .collection('daily')
        .doc(date)
        .collection('locations')
        .orderBy('timestamp')
        .get();

    final locations = locationsSnapshot.docs
        .map((doc) => LocationModel.fromMap(doc.data()))
        .toList();

    if (locations.length < 2) return;

    LocationModel startPoint = locations.first;
    for (int i = 1; i < locations.length; i++) {
      final distance = Geolocator.distanceBetween(
        startPoint.latitude,
        startPoint.longitude,
        locations[i].latitude,
        locations[i].longitude,
      );

      if (distance > _visitRadius) {
        final duration = locations[i - 1].timestamp
            .toDate()
            .difference(startPoint.timestamp.toDate())
            .inMinutes;

        if (duration >= _visitDuration) {
          final visit = VisitModel(
            latitude: startPoint.latitude,
            longitude: startPoint.longitude,
            startTime: startPoint.timestamp,
            endTime: locations[i - 1].timestamp,
          );
          await _realtimeService.addVisit(visit);
        }
        startPoint = locations[i];
      }
    }
  }
}
