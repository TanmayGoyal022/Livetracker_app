import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_tracking_app/firebase_options.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      } catch (e) {
        debugPrint('Failed to initialize Firebase: $e');
        // Handle initialization failure
      }
    }
  }

  // Store location for current session
  Future<void> storeLocation(double lat, double lng, DateTime timestamp) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final date = DateTime.now();
    final sessionId = "${date.year}-${date.month}-${date.day}";

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .doc(sessionId)
        .collection('locations')
        .doc(timestamp.toIso8601String());

    await docRef.set({
      'latitude': lat,
      'longitude': lng,
      'timestamp': timestamp.toIso8601String(),
    });
  }
}
