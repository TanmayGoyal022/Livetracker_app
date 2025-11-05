import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_tracking_app/data/models/location_model.dart';
import 'package:live_tracking_app/data/models/visit_model.dart';

class RealtimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addLocation(LocationModel location) async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      final date = '${now.year}-${now.month}-${now.day}';

      await _firestore
          .collection('tracks')
          .doc(user.uid)
          .collection('daily')
          .doc(date)
          .collection('locations')
          .add(location.toJson());
    }
  }

  Future<void> addVisit(VisitModel visit) async {
    final user = _auth.currentUser;
    if (user != null) {
      final now = DateTime.now();
      final date = '${now.year}-${now.month}-${now.day}';

      await _firestore
          .collection('tracks')
          .doc(user.uid)
          .collection('daily')
          .doc(date)
          .collection('visits')
          .add(visit.toJson());
    }
  }
}
