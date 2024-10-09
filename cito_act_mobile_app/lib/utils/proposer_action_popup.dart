import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/action_service.dart';

class ProposerActionPopup extends StatefulWidget {
  const ProposerActionPopup({super.key});

  @override
  _ProposerActionPopupState createState() => _ProposerActionPopupState();
}

class _ProposerActionPopupState extends State<ProposerActionPopup> {
  XFile? _selectedImage;
  final ActionService _actionService = ActionService();

  // Controllers for the TextFields
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  final TextEditingController _debutController = TextEditingController();
  final TextEditingController _finController = TextEditingController();
  final TextEditingController _besoinController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  String _selectedCountryCode = '+223'; // Default country code (Mali)
  final Uuid uuid = Uuid();

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  // Method to show DatePicker and set the selected date
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF6A96CE),
            hintColor: const Color(0xFF6A96CE),
            colorScheme: ColorScheme.light(primary: const Color(0xFF6A96CE)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedDate != null) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format YYYY-MM-DD
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showDialog(String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isError ? 'Erreur' : 'Succès'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return {
        'firstName': userDoc['firstName'],
        'lastName': userDoc['lastName'],
        'profilePic': userDoc['imageUrl'],
        'userId': user.uid
      };
    }
    throw Exception('Utilisateur non connecté');
  }

  Future<void> _submitAction() async {
    try {
      // Get user data
      final userData = await _getCurrentUserData();
      String actionId = uuid.v4(); // Generate a unique action ID

      await _actionService.createAction(
        actionId: actionId,
        titre: _titreController.text,
        description: _descriptionController.text,
        localisation: _localisationController.text,
        debut: _debutController.text,
        fin: _finController.text,
        besoin: _besoinController.text,
        telephone: _telephoneController.text,
        imageFile: _selectedImage,
        userId: userData['userId'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        profilePic: userData['profilePic'],
      );

      _showDialog('Action proposée avec succès !');
      _clearFields(); // Clear fields after successful submission
    } catch (e) {
      _showDialog('Échec de la proposition de l\'action : $e', isError: true);
    }
  }

  // Method to clear input fields
  void _clearFields() {
    _titreController.clear();
    _descriptionController.clear();
    _localisationController.clear();
    _debutController.clear();
    _finController.clear();
    _besoinController.clear();
    _telephoneController.clear();
    setState(() {
      _selectedImage = null; // Reset selected image
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyboard,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF6A96CE),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _selectedImage != null
                    ? Image.file(
                  File(_selectedImage!.path),
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/default_action_image.png',
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: const Icon(
                    Icons.cloud_upload,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Titre input field
                TextField(
                  controller: _titreController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Donnez un titre à votre projet',
                    hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Description input field as a multi-line textarea
                TextField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Donnez une description à votre projet',
                    hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Besoin input field
                TextField(
                  controller: _besoinController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Besoin',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Quel est le besoin de cette action?',
                    hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Numéro de téléphone input field with country code selection
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedCountryCode,
                      items: <String>['+223', '+225', '+33', '+1'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountryCode = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _telephoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                          hintText: 'Entrez votre numéro de téléphone',
                          hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Localisation input field
                TextField(
                  controller: _localisationController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Localisation',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Localisation de l\'action',
                    hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Date de début input field
                GestureDetector(
                  onTap: () => _selectDate(_debutController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _debutController,
                      decoration: InputDecoration(
                        labelText: 'Date de début',
                        labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                        hintText: 'Sélectionnez la date de début',
                        hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Date de fin input field
                GestureDetector(
                  onTap: () => _selectDate(_finController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _finController,
                      decoration: InputDecoration(
                        labelText: 'Date de fin',
                        labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                        hintText: 'Sélectionnez la date de fin',
                        hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Submit button
                ElevatedButton(
                  onPressed: _submitAction,
                  child: const Text('Proposer l\'action'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
