import 'package:flutter/material.dart';
import 'package:live_tracking_app/core/services/firebase_service.dart';
import 'package:live_tracking_app/core/services/local_data_service.dart';
import 'package:live_tracking_app/presentation/screens/history_screen.dart';
import 'package:live_tracking_app/platform_specific/platform_specific.dart';

void callbackDispatcher() {
  runBackgroundTask();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeApp();
  await LocalDataService().init();

  // Initialize background service (stubbed on unsupported platforms)
  initializeBackgroundService(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HistoryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
