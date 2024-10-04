import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'patient/home.dart';
import 'doctor/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Khởi tạo Firebase với các thông số tùy chỉnh cho nền tảng hiện tại
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print("Lỗi khởi tạo Firebase: $e");
    }
    return; // Ngừng khởi động ứng dụng nếu có lỗi
  }

  runApp(const MyApp());
}

class DefaultFirebaseOptions {
  // ignore: prefer_typing_uninitialized_variables
  static var currentPlatform;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng Đặt Bác Sĩ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Màn hình đăng nhập sẽ là màn hình khởi động
      routes: {
        '/login': (context) => const LoginScreen(),     // Đường dẫn tới trang Đăng Nhập
        '/register': (context) => const RegisterScreen(),  // Đường dẫn tới trang Đăng Ký
        '/patient_home': (context) => const Home(), 
        '/doctor_home': (context) => const HomeScreenDoctor(),            // Đường dẫn tới trang chính (Home)
      },
    );
  }
}
