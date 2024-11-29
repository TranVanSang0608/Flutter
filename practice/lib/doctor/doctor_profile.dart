import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/auth/login_page.dart';
import 'package:practice/change_password_page.dart';
import 'package:practice/doctor/edit_doctor_profile.dart';
import 'package:practice/doctor/model/doctor.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _doctorDatabase =
      FirebaseDatabase.instance.ref().child('Doctors');
  bool _isLoading = true;
  Doctor? _doctor;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _doctorDatabase
          .child(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          setState(() {
            _doctor = Doctor.fromMap(
                Map<String, dynamic>.from(event.snapshot.value as Map),
                currentUserId);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDoctorProfilePage(doctor: _doctor!),
      ),
    );
  }

  void _changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color(0xff0064FA),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            NetworkImage(_doctor?.profileImageUrl ?? ''),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${_doctor?.firstName} ${_doctor?.lastName}',
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _doctor?.qualification ?? '',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        _buildInfoRow(Icons.category, 'Category',
                            _doctor?.category ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.work, 'Years of Experience',
                            _doctor?.yearsOfExperience ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.location_city, 'City', _doctor?.city ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.email, 'Email', _doctor?.email ?? ''),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.phone, 'Phone', _doctor?.phoneNumber ?? ''),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _navigateToEditProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0064FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xff0064FA),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                  color: Color(0xff0064FA), width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                          ),
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff0064FA)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ],
    );
  }
}
