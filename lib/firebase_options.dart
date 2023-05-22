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
    apiKey: 'AIzaSyAR78bGA7b_AJVsvlMsqD0Fiqwy7wXfETY',
    appId: '1:545480137356:web:58eada560e6821e41039a9',
    messagingSenderId: '545480137356',
    projectId: 'clusteroids-e10d0',
    authDomain: 'clusteroids-e10d0.firebaseapp.com',
    databaseURL: 'https://clusteroids-e10d0-default-rtdb.firebaseio.com',
    storageBucket: 'clusteroids-e10d0.appspot.com',
    measurementId: 'G-CK8G53XPC1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxSEIUZlfYAAa_CMAztkTSAEDeJ0po8-0',
    appId: '1:545480137356:android:104e9f955fee2b841039a9',
    messagingSenderId: '545480137356',
    projectId: 'clusteroids-e10d0',
    databaseURL: 'https://clusteroids-e10d0-default-rtdb.firebaseio.com',
    storageBucket: 'clusteroids-e10d0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFchZARNZMrXIrSIPX9G-gpCnVRf051Ns',
    appId: '1:545480137356:ios:507de241d59b9dbc1039a9',
    messagingSenderId: '545480137356',
    projectId: 'clusteroids-e10d0',
    databaseURL: 'https://clusteroids-e10d0-default-rtdb.firebaseio.com',
    storageBucket: 'clusteroids-e10d0.appspot.com',
    androidClientId: '545480137356-l1c7cf5da0lnk9sfan194i5atmvq9fec.apps.googleusercontent.com',
    iosClientId: '545480137356-iltbnns9cgvm8br6k4dunlf1akuf4lo4.apps.googleusercontent.com',
    iosBundleId: 'com.example.clusteroids',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFchZARNZMrXIrSIPX9G-gpCnVRf051Ns',
    appId: '1:545480137356:ios:507de241d59b9dbc1039a9',
    messagingSenderId: '545480137356',
    projectId: 'clusteroids-e10d0',
    databaseURL: 'https://clusteroids-e10d0-default-rtdb.firebaseio.com',
    storageBucket: 'clusteroids-e10d0.appspot.com',
    androidClientId: '545480137356-l1c7cf5da0lnk9sfan194i5atmvq9fec.apps.googleusercontent.com',
    iosClientId: '545480137356-iltbnns9cgvm8br6k4dunlf1akuf4lo4.apps.googleusercontent.com',
    iosBundleId: 'com.example.clusteroids',
  );
}
