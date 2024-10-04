class User {
  final String uid;
  final String email;
  final String role; // 'doctor' hoặc 'patient'
  final String? specialization; // Chuyên môn, có thể null
  final String name; // Tên người dùng
  final String phoneNumber; // Số điện thoại

  User({
    required this.uid,
    required this.email,
    required this.role,
    this.specialization,
    required this.name, // Thêm tên vào constructor
    required this.phoneNumber, // Thêm số điện thoại vào constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'specialization': specialization,
      'name': name, // Thêm tên vào map
      'phoneNumber': phoneNumber, // Thêm số điện thoại vào map
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      specialization: map['specialization'],
      name: map['name'], // Lấy tên từ map
      phoneNumber: map['phoneNumber'], // Lấy số điện thoại từ map
    );
  }
}
