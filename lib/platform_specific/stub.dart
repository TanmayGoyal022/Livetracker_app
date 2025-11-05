import 'package:flutter/material.dart';

void initializeBackgroundService(void Function() callbackDispatcher) {
  // No-op for unsupported platforms
  debugPrint('Background service is not supported on this platform.');
}

void runBackgroundTask() {
  // No-op for unsupported platforms
}
