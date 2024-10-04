import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/users.dart'; // Nhập lớp model User

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';
  String role = 'patient'; // Mặc định là bệnh nhân
  String specialization = ''; // Dành riêng cho bác sĩ
  String name = ''; // Tên người dùng
  String phoneNumber = ''; // Số điện thoại
  bool _isLoading = false; // Trạng thái đang xử lý

  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Bắt đầu xử lý
    });
    try {
      // Tạo tài khoản với Firebase
      firebase.UserCredential userCredential =
          await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo một đối tượng User mới từ model của bạn
      User newUser = User(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
        specialization: role == 'doctor' ? specialization : null,
        name: name, // Thêm tên vào đối tượng User
        phoneNumber: phoneNumber, // Thêm số điện thoại vào đối tượng User
      );

      // Lưu thông tin người dùng vào Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(newUser.uid).set(newUser.toMap());

      // Chuyển đến trang đăng nhập sau khi đăng ký thành công
      Navigator.pushReplacementNamed(context, '/login');
    } on firebase.FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email đã được sử dụng.';
      } else {
        message = 'Đăng ký thất bại: ${e.message}';
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
        title: const Text('Đăng Ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tên'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    } else if (value != password) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                ),
                const SizedBox(height: 10),
                // Dropdown để chọn vai trò
                DropdownButton<String>(
                  value: role,
                  items: <String>['patient', 'doctor'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      role = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Nếu chọn vai trò là bác sĩ, hiển thị trường nhập chuyên môn
                if (role == 'doctor')
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Chuyên môn'),
                    validator: (value) {
                      if (role == 'doctor' &&
                          (value == null || value.isEmpty)) {
                        return 'Vui lòng nhập chuyên môn';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      specialization = value;
                    },
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator() // Hiển thị khi đang xử lý
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _register(); // Gọi hàm đăng ký
                          }
                        },
                        child: const Text('Đăng Ký'),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/login'); // Điều hướng về trang đăng nhập
                  },
                  child: const Text('Đã có tài khoản? Đăng nhập ngay!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
