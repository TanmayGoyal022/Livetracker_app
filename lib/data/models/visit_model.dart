import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final double latitude;
  final double longitude;
  final Timestamp startTime;
  final Timestamp endTime;
  final String? name;

  VisitModel({
    required this.latitude,
    required this.longitude,
    required this.startTime,
    required this.endTime,
    this.name,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'startTime': startTime,
      'endTime': endTime,
      'name': name,
    };
  }
}
