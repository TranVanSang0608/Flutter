// TODO Implement this library.
// firebase_options.dart
// Do not modify the generated file; it may be overwritten when running "flutterfire configure".

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Add your platform-specific initialization code here.
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'Những thông tin này sẽ không có cho Web', // Không cần thông tin cho Web
        appId: 'your_app_id_for_web', // Không cần thiết
        messagingSenderId: 'your_messaging_sender_id_for_web', // Không cần thiết
        projectId: 'pkanghia-27246',
        storageBucket: 'pkanghia-27246.appspot.com',
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDFKuizGlZMwA1qZFaon_3ZZqUfHCyBdzg', // API Key cho Android
        appId: '1:187671765191:android:b0c54674dedd9981b9dee2', // App ID cho Android
        messagingSenderId: '187671765191', // Messaging Sender ID cho Android
        projectId: 'pkanghia-27246',
        storageBucket: 'pkanghia-27246.appspot.com',
      );
    }
  }
}