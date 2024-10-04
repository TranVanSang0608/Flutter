import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'search_screen.dart';

class HomeScreenDoctor extends StatefulWidget {
  const HomeScreenDoctor({super.key});

  @override
  State<HomeScreenDoctor> createState() => _HomeScreenDoctorState();
}

class _HomeScreenDoctorState extends State<HomeScreenDoctor> {
  int _selectedIndex = 0;
  TextEditingController searchController =
      TextEditingController(); // Controller cho ô tìm kiếm

  final List<String> departments = [
    'Khoa Nội',
    'Khoa Ngoại',
    'Khoa Nhi',
    'Khoa Sản',
    'Khoa Tâm thần'
  ]; // Danh sách khoa

  final List<String> doctors = [
    'Trang Bác sĩ A',
    'Bác sĩ B',
    'Bác sĩ C',
    'Bác sĩ D',
    'Bác sĩ E'
  ]; // Danh sách bác sĩ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PKA Doctor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _buildBody(), // Chỉ hiển thị nội dung tương ứng với tab hiện tại
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,
        selectedItemColor: const Color.fromARGB(255, 194, 59, 59),
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Trang chủ
        return _buildHomeScreenDoctorBody();
      case 1: // Màn hình tin nhắn
        return const ChatScreenDoctor();
      case 2: // Màn hình thông báo
        return const NotificationScreenDoctor();
      case 3: // Màn hình tìm kiếm
        return const SearchScreenDoctor();
      case 4: // Màn hình hồ sơ
        return const ProfileScreenDoctor();
      default:
        return const Center(child: Text('Trang không hợp lệ.'));
    }
  }

  Widget _buildHomeScreenDoctorBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              // Điều hướng đến trang tìm kiếm
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchScreenDoctor()),
              );
            },
            child: AbsorbPointer(
              // Ngăn không cho người dùng nhập vào ô này
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Nhập tên bác sĩ, chuyên khoa hoặc địa điểm',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDepartmentCards(), // Hiển thị danh sách khoa
                const SizedBox(height: 20),
                _buildDoctorCards(), // Hiển thị danh sách bác sĩ
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentCards() {
    return SizedBox(
      height: 150, // Chiều cao của danh sách khoa
      child: PageView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                departments[index],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCards() {
    return SizedBox(
      height: 250, // Chiều cao của danh sách bác sĩ
      child: PageView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                doctors[index],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số tab đã chọn
    });
  }
}
