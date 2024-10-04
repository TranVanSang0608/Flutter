import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase; // Sử dụng alias
import 'package:cloud_firestore/cloud_firestore.dart'; // Nhập Firestore
import 'models/users.dart'; // Nhập lớp model User

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false; // Để hiển thị trạng thái đang xử lý

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Bắt đầu quá trình xử lý
    });
    try {
      // Đăng nhập người dùng với Firebase
      firebase.UserCredential userCredential = await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy thông tin người dùng từ Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      User loggedInUser = User.fromMap(userDoc.data() as Map<String, dynamic>);

      // Nếu đăng nhập thành công, kiểm tra vai trò và điều hướng
      if (loggedInUser.role == 'doctor') {
        Navigator.pushReplacementNamed(context, '/doctor_home'); // Trang cho bác sĩ
      } else {
        Navigator.pushReplacementNamed(context, '/patient_home'); // Trang cho bệnh nhân
      }

    } on firebase.FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Không tìm thấy người dùng với email này.';
      } else if (e.code == 'wrong-password') {
        message = 'Mật khẩu không chính xác.';
      } else {
        message = 'Đăng nhập thất bại: ${e.message}';
      }

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hoàn tất quá trình xử lý
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator() // Hiển thị khi đang xử lý
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login(); // Gọi hàm đăng nhập
                        }
                      },
                      child: const Text('Đăng Nhập'),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: const Text('Chưa có tài khoản? Đăng ký ngay!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}