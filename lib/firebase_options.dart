import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmpKVZv4r5e531KkbnvbtLxwiToDu59s4',
    appId: '1:791661110009:web:90aa32b9c7c330ac06b828',
    messagingSenderId: '791661110009',
    projectId: 'crudfirebase-d6fc5',
    authDomain: 'crudfirebase-d6fc5.firebaseapp.com',
    storageBucket: 'crudfirebase-d6fc5.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmpKVZv4r5e531KkbnvbtLxwiToDu59s4',
    appId: '1:791661110009:android:0ce82bd053a6471006b828',
    messagingSenderId: '791661110009',
    projectId: 'crudfirebase-d6fc5',
    storageBucket: 'crudfirebase-d6fc5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmpKVZv4r5e531KkbnvbtLxwiToDu59s4',
    appId: '1:791661110009:ios:2afbfdbb699405de06b828',
    messagingSenderId: '791661110009',
    projectId: 'crudfirebase-d6fc5',
    storageBucket: 'crudfirebase-d6fc5.firebasestorage.app',
    iosBundleId: 'com.mifirebase.crudfirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmpKVZv4r5e531KkbnvbtLxwiToDu59s4',
    appId: '1:791661110009:ios:2afbfdbb699405de06b828',
    messagingSenderId: '791661110009',
    projectId: 'crudfirebase-d6fc5',
    storageBucket: 'crudfirebase-d6fc5.firebasestorage.app',
    iosBundleId: 'com.mifirebase.crudfirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmpKVZv4r5e531KkbnvbtLxwiToDu59s4',
    appId: '1:791661110009:web:60051fad7072d9bd06b828',
    messagingSenderId: '791661110009',
    projectId: 'crudfirebase-d6fc5',
    authDomain: 'crudfirebase-d6fc5.firebaseapp.com',
    storageBucket: 'crudfirebase-d6fc5.firebasestorage.app',
  );
}
