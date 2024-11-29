import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/auth/login_page.dart';
import 'package:practice/change_password_page.dart';
import 'package:practice/edit_profile_page.dart';
import 'doctor/model/patient.dart';
import 'doctor/model/booking.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _requestDatabase =
      FirebaseDatabase.instance.ref().child('Requests');
  final DatabaseReference _patientDatabase =
      FirebaseDatabase.instance.ref().child('Patients');
  List<Booking> _bookings = [];
  bool _isLoading = true;
  Patient? _patient;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _fetchPatientData();
  }

  Future<void> _fetchBookings() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _requestDatabase
          .orderByChild('sender')
          .equalTo(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> bookingMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          List<Booking> tempBookings = [];
          bookingMap.forEach((key, value) {
            tempBookings.add(Booking.fromMap(Map<String, dynamic>.from(value)));
          });
          setState(() {
            _bookings = tempBookings;
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

  Future<void> _fetchPatientData() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _patientDatabase
          .child(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          setState(() {
            _patient = Patient.fromMap(
                Map<String, dynamic>.from(event.snapshot.value as Map));
          });
        }
      });
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(patient: _patient!),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle profile image change
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(_patient?.profileImageUrl ?? ''),
                        backgroundColor: const Color(0xffF0EFFF),
                        child: _patient?.profileImageUrl == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 60,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${_patient?.firstName} ${_patient?.lastName}',
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffF0EFFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _patient?.email ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: const Color(0xff0064FA)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(_patient?.phoneNumber ?? ''),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(_patient?.city ?? ''),
                    ),
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
                    Text(
                      'Booking History',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _bookings.isEmpty
                        ? const Center(child: Text('No booking available'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _bookings.length,
                            itemBuilder: (context, index) {
                              final booking = _bookings[index];
                              return ListTile(
                                title: Text(booking.description),
                                subtitle: Text(
                                    'Date: ${booking.date} Time: ${booking.time}'),
                                trailing: Text(booking.status),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
