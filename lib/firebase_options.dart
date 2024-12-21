// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.windows);
  runApp(MyApp());
}
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );

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
        return windows;
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
    apiKey: 'AIzaSyA5mJd9Y_EWWMp-sibL5aLiEL0gGc32-sg',
    appId: '1:235483151253:web:ac3f344ac3106e9412549c',
    messagingSenderId: '235483151253',
    projectId: 'expensees-47f16',
    authDomain: 'expensees-47f16.firebaseapp.com',
    storageBucket: 'expensees-47f16.firebasestorage.app',
    measurementId: 'G-W7VNVKVX86',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnSmd-nYIdMocsYotIPFMFor61thxAnuw',
    appId: '1:235483151253:android:eb35fd235a5772a012549c',
    messagingSenderId: '235483151253',
    projectId: 'expensees-47f16',
    storageBucket: 'expensees-47f16.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYSMZy0ZWd33wn6MlTFM1rlcy_UqQpGRA',
    appId: '1:235483151253:ios:40f159ef06f8e17f12549c',
    messagingSenderId: '235483151253',
    projectId: 'expensees-47f16',
    storageBucket: 'expensees-47f16.firebasestorage.app',
    iosBundleId: 'com.example.flutterDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYSMZy0ZWd33wn6MlTFM1rlcy_UqQpGRA',
    appId: '1:235483151253:ios:40f159ef06f8e17f12549c',
    messagingSenderId: '235483151253',
    projectId: 'expensees-47f16',
    storageBucket: 'expensees-47f16.firebasestorage.app',
    iosBundleId: 'com.example.flutterDemo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5mJd9Y_EWWMp-sibL5aLiEL0gGc32-sg',
    appId: '1:235483151253:web:0267a552d5318d7a12549c',
    messagingSenderId: '235483151253',
    projectId: 'expensees-47f16',
    authDomain: 'expensees-47f16.firebaseapp.com',
    storageBucket: 'expensees-47f16.firebasestorage.app',
    measurementId: 'G-Y8SFNBQ3J1',
  );
}
