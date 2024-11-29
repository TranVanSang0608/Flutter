import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/doctor/doctor_details_page.dart';
import 'package:practice/doctor/model/doctor.dart';
import 'package:practice/doctor/widget/doctor_card.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Doctors');
  List<Doctor> _doctors = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCategory = 'All';
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      final DatabaseEvent event = await _database.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        setState(() {
          _doctors = [];
          _isLoading = false;
        });
        return;
      }

      final Map<dynamic, dynamic> values =
          snapshot.value as Map<dynamic, dynamic>;
      final List<Doctor> tmpDoctors = values.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        return Doctor.fromMap(value, key);
      }).toList();

      setState(() {
        _doctors = tmpDoctors;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching doctors: $e');
      // Optionally, you can show an error message to the user here
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Doctor> _getFilteredDoctors() {
    if (_selectedCategory == 'All') {
      return _doctors;
    } else {
      return _doctors
          .where((doctor) =>
              doctor.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Find your doctor,\nand book an appointment',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Find Doctor by Category',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard(
                        context,
                        'Cardiologist',
                        'assets/images/cardiology.png',
                        isHighlighed: _selectedCategory == 'Cardiologist',
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'Cardiologist';
                          });
                        },
                      ),
                      _buildCategoryCard(
                        context,
                        'Dentist',
                        'assets/images/dentistry_24.png',
                        isHighlighed: _selectedCategory == 'Dentist',
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'Dentist';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard(
                        context,
                        'Oncologist',
                        'assets/images/oncology.png',
                        isHighlighed: _selectedCategory == 'Oncologist',
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'Oncologist';
                          });
                        },
                      ),
                      _buildCategoryCard(
                        context,
                        'All',
                        'assets/images/border_all.png',
                        isHighlighed: _selectedCategory == 'All',
                        onTap: () {
                          setState(() {
                            _selectedCategory = 'All';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Doctors',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'VIEW ALL',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff006AFA),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getFilteredDoctors().length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorDetailPage(
                                    doctor: _getFilteredDoctors()[index]),
                              ),
                            );
                          },
                          child:
                              DoctorCard(doctor: _getFilteredDoctors()[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget _buildCategoryCard(BuildContext context, String title, dynamic icon,
    {bool isHighlighed = false, VoidCallback? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            color: isHighlighed
                ? const Color(0xff006AFA)
                : const Color(0xffF0EFFF),
            borderRadius: BorderRadius.circular(15),
            border: isHighlighed
                ? null
                : Border.all(color: const Color(0xffC8C4FF), width: 2)),
        child: Card(
          color:
              isHighlighed ? const Color(0xff006AFA) : const Color(0xffF0EFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon is IconData)
                  Icon(
                    icon,
                    size: 40,
                    color:
                        isHighlighed ? Colors.white : const Color(0xffF0EFFF),
                  )
                else
                  Image.asset(
                    icon,
                    width: 40,
                    height: 40,
                  ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color:
                        isHighlighed ? Colors.white : const Color(0xff006AFA),
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}
