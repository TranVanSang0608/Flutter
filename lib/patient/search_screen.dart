import 'package:flutter/material.dart';
import '../../doctor.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Danh sách bác sĩ
  List<Doctor> doctors = [
    Doctor(
      id: '1',
      name: 'Dr. John Doe',
      specialty: 'Cardiology',
      imageUrl: 'assets/images/doctor1.png',
      location: 'Hà Nội',
      rating: 4.5,
    ),
    Doctor(
      id: '2',
      name: 'Dr. Jane Smith',
      specialty: 'Neurology',
      imageUrl: 'assets/images/doctor2.png',
      location: 'Hồ Chí Minh',
      rating: 4.8,
    ),
    // Thêm bác sĩ khác nếu cần
  ];

  List<Doctor> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors; // Hiển thị tất cả bác sĩ ban đầu
  }

  // Hàm lọc bác sĩ dựa trên từ khóa tìm kiếm
  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
               doctor.specialty.toLowerCase().contains(query) ||
               doctor.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Nhập tên bác sĩ, chuyên khoa hoặc địa điểm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterDoctors(); // Gọi hàm lọc khi có sự thay đổi
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(filteredDoctors[index].imageUrl),
                    ),
                    title: Text(filteredDoctors[index].name),
                    subtitle: Text('${filteredDoctors[index].specialty} - ${filteredDoctors[index].location}'),
                    trailing: Text('${filteredDoctors[index].rating} ⭐'),
                    onTap: () {
                      // Hành động khi nhấn vào bác sĩ (có thể thêm tính năng chi tiết ở đây)
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
