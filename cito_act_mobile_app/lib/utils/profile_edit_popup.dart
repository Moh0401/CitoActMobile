import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class ProfileEditPopup extends StatefulWidget {
  final UserModel user; // Passez l'utilisateur à modifier

  const ProfileEditPopup({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileEditPopupState createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  XFile? _selectedImage;
  final _storageService = StorageService();

  // TextEditingControllers pour les champs modifiables
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs actuelles de l'utilisateur
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _updateUserProfile() async {
    String? imageUrl = widget.user.imageUrl;

    // Si une nouvelle image a été sélectionnée, téléchargez-la
    if (_selectedImage != null) {
      File imageFile = File(_selectedImage!.path);
      imageUrl = await _storageService.uploadImage(imageFile, widget.user.uid);
    }

    // Mettre à jour les informations de l'utilisateur dans Firestore
    final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    await userDoc.update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'imageUrl': imageUrl, // URL de l'image mise à jour
    });

    Navigator.of(context).pop(); // Fermez la popup une fois les modifications effectuées
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
          color: const Color(0xFF6A96CE),
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
                backgroundImage: widget.user.imageUrl != null
                    ? NetworkImage(widget.user.imageUrl!)
                    : AssetImage('assets/images/profile_pic.png') as ImageProvider,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: const Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Nom field
              _buildTextField(label: "Nom", controller: _lastNameController),
              const SizedBox(height: 10),
              // Prénom field
              _buildTextField(label: "Prénom", controller: _firstNameController),
              const SizedBox(height: 10),
              // Email field
              _buildTextField(label: "Email", controller: _emailController),
              const SizedBox(height: 10),
              // Téléphone field
              _buildTextField(label: "Tél", controller: _phoneController),
              const SizedBox(height: 20),
              // Modifier button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF6A96CE),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: _updateUserProfile,
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
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF2F313F)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
