import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreenDoctor extends StatefulWidget {
  const ProfileScreenDoctor({super.key});

  @override
  _ProfileScreenDoctorState createState() => _ProfileScreenDoctorState();
}

class _ProfileScreenDoctorState extends State<ProfileScreenDoctor> {
  // Thông tin cá nhân từ Firebase Auth
  User? user; // Thông tin người dùng đăng nhập

  // Khởi tạo form key để xác thực form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    // Lấy thông tin người dùng đã đăng nhập từ Firebase Auth
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ'),
      ),
      body: SingleChildScrollView( // Bọc nội dung trong SingleChildScrollView để cho phép cuộn
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50, // Bán kính của avatar
                    backgroundImage: AssetImage('assets/images/profile.png'), // Đường dẫn đến ảnh đại diện
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Thông Tin Cá Nhân',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField('Họ và tên', user?.displayName ?? 'Chưa có tên', (value) {
                  setState(() {
                    // Khi cập nhật thông tin người dùng
                  });
                }),
                _buildTextField('Email', user?.email ?? 'Chưa có email', (value) {
                  setState(() {
                    // Khi cập nhật email người dùng
                  });
                }),
                _buildTextField('Số điện thoại', user?.phoneNumber ?? 'Chưa có số điện thoại', (value) {
                  setState(() {
                    // Khi cập nhật số điện thoại
                  });
                }),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thông tin đã được cập nhật!')),
                        );
                      }
                    },
                    child: const Text('Cập nhật thông tin'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Màu nền đỏ cho nút đăng xuất
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Đăng xuất'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập thông tin';
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
              FirebaseAuth.instance.signOut(); // Thực hiện đăng xuất từ Firebase
              Navigator.pushReplacementNamed(context, '/login'); // Điều hướng đến màn hình đăng nhập
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}


