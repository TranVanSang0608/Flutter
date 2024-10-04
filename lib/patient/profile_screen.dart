import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String displayName = '';
  String email = '';
  String phoneNumber = '';
  String imageUrl = 'assets/images/profile.png';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    if (user != null) {
      setState(() {
        displayName = user!.displayName ?? 'Chưa cập nhật tên';
        email = user!.email ?? 'Chưa có email';
        phoneNumber = user!.phoneNumber ?? 'Chưa cập nhật số điện thoại';
        imageUrl = user!.photoURL ?? imageUrl;
      });
    }
  }

  Future<void> _updateUserInfo() async {
    if (user != null) {
      await user!.updateProfile(displayName: 'name', photoURL: 'URL ảnh mới');
      await user!.reload();
      user = FirebaseAuth.instance.currentUser; // Tải lại thông tin mới
      _loadUserInfo(); // Tải lại thông tin sau khi cập nhật
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/images/profile.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Tên:', displayName),
            _buildInfoRow('Email:', email),
            _buildInfoRow('Số điện thoại:', phoneNumber),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _updateUserInfo(); // Gọi phương thức cập nhật thông tin
              },
              child: const Text('Cập nhật thông tin'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
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
              FirebaseAuth.instance.signOut(); // Thực hiện đăng xuất
              Navigator.pushReplacementNamed(context, '/login'); // Điều hướng đến màn hình đăng nhập
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}