// Generated Firebase options - edited with provided project values
// ignore_for_file: public_member_api_docs
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCCqLX9VLROYj3nSL6ldyArFhqMFeew2Nc',
    appId: '1:757144083751:web:REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '757144083751',
    projectId: 'livetrackingapp-f881e',
    authDomain: 'livetrackingapp-f881e.firebaseapp.com',
    storageBucket: 'livetrackingapp-f881e.appspot.com',
    measurementId: 'G-REPLACE_WITH_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCqLX9VLROYj3nSL6ldyArFhqMFeew2Nc',
    appId: '1:757144083751:android:bc7901abdc0323c1221d02',
    messagingSenderId: '757144083751',
    projectId: 'livetrackingapp-f881e',
    storageBucket: 'livetrackingapp-f881e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_IOS_API_KEY',
    appId: 'REPLACE_IOS_APP_ID',
    messagingSenderId: '757144083751',
    projectId: 'livetrackingapp-f881e',
    storageBucket: 'livetrackingapp-f881e.appspot.com',
    iosClientId: 'REPLACE_IOS_CLIENT_ID',
    iosBundleId: 'REPLACE_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_MACOS_API_KEY',
    appId: 'REPLACE_MACOS_APP_ID',
    messagingSenderId: '757144083751',
    projectId: 'livetrackingapp-f881e',
    storageBucket: 'livetrackingapp-f881e.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCCqLX9VLROYj3nSL6ldyArFhqMFeew2Nc',
    appId: '1:757144083751:windows:REPLACE_WITH_WINDOWS_APP_ID',
    messagingSenderId: '757144083751',
    projectId: 'livetrackingapp-f881e',
    storageBucket: 'livetrackingapp-f881e.appspot.com',
  );

  static const FirebaseOptions linux = windows;
}