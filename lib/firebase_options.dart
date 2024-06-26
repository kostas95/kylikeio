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
    apiKey: 'AIzaSyDszvvlWMA_-Z3Da4rdBcuahu5LDDSWcno',
    appId: '1:459425673243:web:d6d0bd2e916c020861c8be',
    messagingSenderId: '459425673243',
    projectId: 'kylikeio-ddb41',
    authDomain: 'kylikeio-ddb41.firebaseapp.com',
    storageBucket: 'kylikeio-ddb41.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDe-L2yAFe4bbB52sOAUuIUgmGyBDP8WHw',
    appId: '1:459425673243:android:d0be7f0e6f9d5b7e61c8be',
    messagingSenderId: '459425673243',
    projectId: 'kylikeio-ddb41',
    storageBucket: 'kylikeio-ddb41.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC99qTufoc81wThon2x1d7TE05OF2Ci-5A',
    appId: '1:459425673243:ios:802c1c2b81835f6461c8be',
    messagingSenderId: '459425673243',
    projectId: 'kylikeio-ddb41',
    storageBucket: 'kylikeio-ddb41.appspot.com',
    iosBundleId: 'com.example.kylikeio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC99qTufoc81wThon2x1d7TE05OF2Ci-5A',
    appId: '1:459425673243:ios:802c1c2b81835f6461c8be',
    messagingSenderId: '459425673243',
    projectId: 'kylikeio-ddb41',
    storageBucket: 'kylikeio-ddb41.appspot.com',
    iosBundleId: 'com.example.kylikeio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDszvvlWMA_-Z3Da4rdBcuahu5LDDSWcno',
    appId: '1:459425673243:web:b50ab611d655ef7b61c8be',
    messagingSenderId: '459425673243',
    projectId: 'kylikeio-ddb41',
    authDomain: 'kylikeio-ddb41.firebaseapp.com',
    storageBucket: 'kylikeio-ddb41.appspot.com',
  );

  /// Old project data
  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyAjWfZe57o4ex58xj5kdqkG5QaN8yHWc48',
  //   appId: '1:677063786723:web:dfe6c80d9948e7684005d6',
  //   messagingSenderId: '677063786723',
  //   projectId: 'kylikeio-57a7d',
  //   authDomain: 'kylikeio-57a7d.firebaseapp.com',
  //   storageBucket: 'kylikeio-57a7d.appspot.com',
  // );
  //
  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyAln6NsOuS29OOJsIcHECiBzcUzU0ZbsFg',
  //   appId: '1:677063786723:android:25090de33bb7b3074005d6',
  //   messagingSenderId: '677063786723',
  //   projectId: 'kylikeio-57a7d',
  //   storageBucket: 'kylikeio-57a7d.appspot.com',
  // );
  //
  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyDa9IHYGOl_WlvobXr2hFuvFzFil2WbgWI',
  //   appId: '1:677063786723:ios:c5651ecf400a43054005d6',
  //   messagingSenderId: '677063786723',
  //   projectId: 'kylikeio-57a7d',
  //   storageBucket: 'kylikeio-57a7d.appspot.com',
  //   iosBundleId: 'com.example.kylikeio',
  // );
  //
  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyDa9IHYGOl_WlvobXr2hFuvFzFil2WbgWI',
  //   appId: '1:677063786723:ios:de60f4049a2846974005d6',
  //   messagingSenderId: '677063786723',
  //   projectId: 'kylikeio-57a7d',
  //   storageBucket: 'kylikeio-57a7d.appspot.com',
  //   iosBundleId: 'com.example.kylikeio.RunnerTests',
  // );
}
