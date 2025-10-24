import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class FirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      throw UnsupportedError(
        'FirebaseConfig belum dikonfigurasi untuk web. '
            'Silakan jalankan kembali FlutterFire CLI untuk setup web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidOptions;
      case TargetPlatform.iOS:
        return _iosOptions;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'FirebaseConfig belum dikonfigurasi untuk macOS. '
              'Jalankan FlutterFire CLI untuk mengonfigurasinya.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'FirebaseConfig belum dikonfigurasi untuk Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseConfig belum dikonfigurasi untuk Linux.',
        );
      default:
        throw UnsupportedError(
          'Platform ini tidak didukung oleh FirebaseConfig.',
        );
    }
  }

  static const FirebaseOptions _androidOptions = FirebaseOptions(
    apiKey: 'AIzaSyDCXHNmyQVv37aNVf28c4RPOseCsp9_cIw',
    appId: '1:438161235133:android:982b3900fa84aa9890ebd4',
    messagingSenderId: '438161235133',
    projectId: 'mascan-1dc42',
    storageBucket: 'mascan-1dc42.firebasestorage.app',
  );

  static const FirebaseOptions _iosOptions = FirebaseOptions(
    apiKey: 'AIzaSyCOt8x2iAL6WZGxjQoOQEBD0ycMilxI_kc',
    appId: '1:438161235133:ios:3df84b752fe5baf490ebd4',
    messagingSenderId: '438161235133',
    projectId: 'mascan-1dc42',
    storageBucket: 'mascan-1dc42.firebasestorage.app',
    iosBundleId: 'com.example.mascan',
  );
}
