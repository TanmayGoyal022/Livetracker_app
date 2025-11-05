import 'package:flutter/foundation.dart';

import 'dart:io' show Platform;

import 'package:live_tracking_app/platform_specific/mobile.dart' as mobile;
import 'package:live_tracking_app/platform_specific/stub.dart' as stub;

void initializeBackgroundService(void Function() callbackDispatcher) {
  if (kIsWeb) {
    // No-op for web
  } else if (Platform.isAndroid || Platform.isIOS) {
    mobile.initializeBackgroundService(callbackDispatcher);
  } else {
    stub.initializeBackgroundService(callbackDispatcher);
  }
}

void runBackgroundTask() {
  if (kIsWeb) {
    // No-op for web
  } else if (Platform.isAndroid || Platform.isIOS) {
    mobile.runBackgroundTask();
  } else {
    stub.runBackgroundTask();
  }
}
