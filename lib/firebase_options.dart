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
    apiKey: 'AIzaSyABSq7wTIpyS1JLA_oy4iocLP9UEyEN6A8',
    appId: '1:950960231767:web:3bd7b8bd661ebd4f49da12',
    messagingSenderId: '950960231767',
    projectId: 'thansohoc-1',
    authDomain: 'thansohoc-1.firebaseapp.com',
    storageBucket: 'thansohoc-1.appspot.com',
    measurementId: 'G-R574ZHY9EP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZTlMnG-q9oZtR0Vef6N4tmjK1LHp2j7w',
    appId: '1:950960231767:android:60e3d6507b3021e649da12',
    messagingSenderId: '950960231767',
    projectId: 'thansohoc-1',
    storageBucket: 'thansohoc-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcSnVeDQ0fxsiTDPjzsLay1MCdAoT0nmA',
    appId: '1:950960231767:ios:9d450aed3cccfaa349da12',
    messagingSenderId: '950960231767',
    projectId: 'thansohoc-1',
    storageBucket: 'thansohoc-1.appspot.com',
    iosClientId: '950960231767-c65ru7mohoibj43imh0c63pghmd1lfm2.apps.googleusercontent.com',
    iosBundleId: 'com.example.thansohoc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcSnVeDQ0fxsiTDPjzsLay1MCdAoT0nmA',
    appId: '1:950960231767:ios:9d450aed3cccfaa349da12',
    messagingSenderId: '950960231767',
    projectId: 'thansohoc-1',
    storageBucket: 'thansohoc-1.appspot.com',
    iosClientId: '950960231767-c65ru7mohoibj43imh0c63pghmd1lfm2.apps.googleusercontent.com',
    iosBundleId: 'com.example.thansohoc',
  );
}
