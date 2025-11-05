import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }
}
