// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDddZZbFId6Nifvr2IADIcLV_1MjCsCrF0',
    appId: '1:843925357482:web:d0e8850c6bc33e3924a1d3',
    messagingSenderId: '843925357482',
    projectId: 'live-chat-98404',
    authDomain: 'live-chat-98404.firebaseapp.com',
    storageBucket: 'live-chat-98404.appspot.com',
    measurementId: 'G-MKJ6210NDR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWgMCO9eciPZrAxqNXPjZoOIaNTh9gPrs',
    appId: '1:843925357482:android:84be2723332c609824a1d3',
    messagingSenderId: '843925357482',
    projectId: 'live-chat-98404',
    storageBucket: 'live-chat-98404.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeczzIIOhfwDpq4CS_aL9RKjT_KSXEjpU',
    appId: '1:843925357482:ios:3bb5037138cd7c9124a1d3',
    messagingSenderId: '843925357482',
    projectId: 'live-chat-98404',
    storageBucket: 'live-chat-98404.appspot.com',
    iosClientId: '843925357482-pq0bdtks9j54dtst2oudfqufbt44qj9h.apps.googleusercontent.com',
    iosBundleId: 'com.example.liveChatUsingFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeczzIIOhfwDpq4CS_aL9RKjT_KSXEjpU',
    appId: '1:843925357482:ios:d359195552f32be524a1d3',
    messagingSenderId: '843925357482',
    projectId: 'live-chat-98404',
    storageBucket: 'live-chat-98404.appspot.com',
    iosClientId: '843925357482-4on6fqhhvr2slnuc88jgcqfm69u2h955.apps.googleusercontent.com',
    iosBundleId: 'com.example.liveChatUsingFirebase.RunnerTests',
  );
}
