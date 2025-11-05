import 'package:flutter/material.dart';

void initializeBackgroundService(void Function() callbackDispatcher) {
  // No-op for web
  debugPrint('Background service is not supported on this platform.');
}

void runBackgroundTask() {
  // No-op for web
}
