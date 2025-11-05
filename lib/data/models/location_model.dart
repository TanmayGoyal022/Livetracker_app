import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final DateTime timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      timestamp: (map['timestamp'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }
}
