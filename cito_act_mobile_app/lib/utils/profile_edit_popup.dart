import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPopup extends StatefulWidget {
  const ProfileEditPopup({super.key});

  @override
  _ProfileEditPopupState createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xFF6A96CE), // Background color #6A96CE
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Avatar section with image picker
              _selectedImage != null
                  ? CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(File(_selectedImage!.path)),
              )
                  : CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile_pic.png'), // Default image
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage, // Opens the image picker
                child: const Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Nom field
              _buildTextField(label: "Nom", value: "Traoré"),
              const SizedBox(height: 10),
              // Prénom field
              _buildTextField(label: "Prénom", value: "Mohamed"),
              const SizedBox(height: 10),
              // Email field
              _buildTextField(label: "Email", value: "mohamed@gmail.com"),
              const SizedBox(height: 10),
              // Téléphone field
              _buildTextField(label: "Tél", value: "+223 76435578"),
              const SizedBox(height: 10),
              // Mot de passe field
              _buildPasswordField(),
              const SizedBox(height: 20),
              // Modifier button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF6A96CE),
                  backgroundColor: Colors.white, // Button background
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  // Logic to execute when the "MODIFIER" button is pressed
                },
                child: const Text(
                  'MODIFIER',
                  style: TextStyle(
                    color: Color(0xFF6A96CE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for TextFields
  Widget _buildTextField({required String label, required String value}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF2F313F)),
        hintText: value,
        hintStyle: const TextStyle(color: Color(0xFF2F313F)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Password Field with eye icon
  Widget _buildPasswordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        labelStyle: const TextStyle(color: Color(0xFF2F313F)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: const Icon(Icons.visibility, color: Color(0xFF2F313F)),
          onPressed: () {
            // Logic to show/hide password
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
