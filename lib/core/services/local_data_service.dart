import 'package:hive_flutter/hive_flutter.dart';
import 'package:live_tracking_app/data/models/location_model.dart';
import 'package:path_provider/path_provider.dart';

class LocalDataService {
  late Box<LocationModel> _locationBox;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(LocationModelAdapter());
    _locationBox = await Hive.openBox<LocationModel>('locations');
  }

  Future<void> addLocation(LocationModel location) async {
    await _locationBox.add(location);
  }

  List<LocationModel> getAllLocations() {
    return _locationBox.values.toList();
  }

  Future<void> clearLocations() async {
    await _locationBox.clear();
  }
}
