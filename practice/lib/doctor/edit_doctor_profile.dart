// edit_doctor_profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/doctor/model/doctor.dart'; // Adjust the import based on your project structure
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class EditDoctorProfilePage extends StatefulWidget {
  final Doctor doctor;

  const EditDoctorProfilePage({required this.doctor, Key? key})
      : super(key: key);

  @override
  _EditDoctorProfilePageState createState() => _EditDoctorProfilePageState();
}

class _EditDoctorProfilePageState extends State<EditDoctorProfilePage> {
  late TextEditingController _categoryController;
  late TextEditingController _cityController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _qualificationController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _yearsOfExperienceController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.doctor.category);
    _cityController = TextEditingController(text: widget.doctor.city);
    _emailController = TextEditingController(text: widget.doctor.email);
    _firstNameController = TextEditingController(text: widget.doctor.firstName);
    _lastNameController = TextEditingController(text: widget.doctor.lastName);
    _qualificationController =
        TextEditingController(text: widget.doctor.qualification);
    _phoneNumberController =
        TextEditingController(text: widget.doctor.phoneNumber);
    _yearsOfExperienceController =
        TextEditingController(text: widget.doctor.yearsOfExperience);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _qualificationController.dispose();
    _phoneNumberController.dispose();
    _yearsOfExperienceController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;
    String qualification = _qualificationController.text;
    String category = _categoryController.text;
    String city = _cityController.text;
    String yearsOfExperience = _yearsOfExperienceController.text;

    // Validate input fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Additional validation for email format if needed
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Update the user's email if it has changed
        if (user.email != email) {
          await user.updateEmail(email);
        }

        // Assuming you have a method to update the user's profile in your backend
        final response = await http.put(
          Uri.parse(
              'https://yourapi.com/doctors/${user.uid}'), // Adjust the URL
          headers: {
            'Content-Type': 'application/json',
            // Include any authentication tokens if needed
          },
          body: jsonEncode({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'phoneNumber': phoneNumber,
            'qualification': qualification,
            'category': category,
            'city': city,
            'yearsOfExperience': yearsOfExperience,
          }),
        );

        // Check if the update was successful
        if (response.statusCode == 200) {
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );

          // Navigate back to the profile page
          Navigator.pop(context);
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update profile: ${response.body}')),
          );
        }
      }
    } catch (e) {
      // Show an error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Doctor Profile',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qualificationController,
                decoration: InputDecoration(
                  labelText: 'Qualification',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearsOfExperienceController,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  labelStyle:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff0064FA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xff0064FA), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0064FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
