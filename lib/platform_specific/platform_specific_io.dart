import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_tracking_app/core/services/firebase_service.dart';
import 'package:live_tracking_app/core/services/realtime_service.dart';
import 'package:live_tracking_app/core/services/visit_detection_service.dart';
import 'package:live_tracking_app/data/models/location_model.dart';
import 'package:workmanager/workmanager.dart';

void initializeBackgroundService(void Function() callbackDispatcher) {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "trackLocation",
    "updateLocation",
    frequency: const Duration(minutes: 15),
  );
}

void runBackgroundTask() {
  Workmanager().executeTask((task, inputData) async {
    await FirebaseService.initializeApp();
    final realtimeService = RealtimeService();
    final visitDetectionService = VisitDetectionService();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final location = LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: Timestamp.now(),
    );

    await realtimeService.addLocation(location);
    await visitDetectionService.detectAndSaveVisits();

    return Future.value(true);
  });
}
