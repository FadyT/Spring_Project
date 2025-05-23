// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBt85U8D42UJ8R06z075QV5L33T83rzWwQ',
    appId: '1:999349533286:web:bf33864db948ff26fc8ba7',
    messagingSenderId: '999349533286',
    projectId: 'simplefluttersavedata',
    authDomain: 'simplefluttersavedata.firebaseapp.com',
    storageBucket: 'simplefluttersavedata.firebasestorage.app',
    measurementId: 'G-DRNJTCLGPG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1Ooj6tx39ZEiTTZuktPnJUpt2_TCh5-M',
    appId: '1:999349533286:android:a71c17b86599775dfc8ba7',
    messagingSenderId: '999349533286',
    projectId: 'simplefluttersavedata',
    storageBucket: 'simplefluttersavedata.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2nqhqLXuiVWca5Cl7Pvw5QbttpMqP3yw',
    appId: '1:999349533286:ios:a1629fbb11042653fc8ba7',
    messagingSenderId: '999349533286',
    projectId: 'simplefluttersavedata',
    storageBucket: 'simplefluttersavedata.firebasestorage.app',
    iosBundleId: 'com.example.simpleProjectSaveReadFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2nqhqLXuiVWca5Cl7Pvw5QbttpMqP3yw',
    appId: '1:999349533286:ios:a1629fbb11042653fc8ba7',
    messagingSenderId: '999349533286',
    projectId: 'simplefluttersavedata',
    storageBucket: 'simplefluttersavedata.firebasestorage.app',
    iosBundleId: 'com.example.simpleProjectSaveReadFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBt85U8D42UJ8R06z075QV5L33T83rzWwQ',
    appId: '1:999349533286:web:c88eff59f277f389fc8ba7',
    messagingSenderId: '999349533286',
    projectId: 'simplefluttersavedata',
    authDomain: 'simplefluttersavedata.firebaseapp.com',
    storageBucket: 'simplefluttersavedata.firebasestorage.app',
    measurementId: 'G-6RRG8KVNBV',
  );
}
