import 'package:geolocator/geolocator.dart';

class LocationUtils {
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream();
  }
}
