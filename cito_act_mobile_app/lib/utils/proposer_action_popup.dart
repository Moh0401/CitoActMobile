import 'dart:io';
import 'package:cito_act_mobile_app/services/action_service.dart';
import 'package:cito_act_mobile_app/services/projet_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProposerActionPopup extends StatefulWidget {
  const ProposerActionPopup({super.key});

  @override
  _ProposerActionPopupState createState() => _ProposerActionPopupState();
}

class _ProposerActionPopupState extends State<ProposerActionPopup> {
  XFile? _selectedImage;
  bool _isLoading = false; // Ajouter l'état de chargement


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
    // Si c'est la date de début
    if (controller == _debutController) {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
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
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        // Réinitialiser la date de fin si elle existe déjà
        _finController.clear();
      }
    }
    // Si c'est la date de fin
    else if (controller == _finController) {
      // Vérifier si une date de début a été sélectionnée
      if (_debutController.text.isEmpty) {
        _showDialog('Veuillez d\'abord sélectionner une date de début', isError: true);
        return;
      }

      DateTime dateDebut = DateTime.parse(_debutController.text);
      DateTime maxDate = dateDebut.add(const Duration(days: 7)); // Maximum 7 jours après la date de début

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateDebut,
        firstDate: dateDebut,
        lastDate: maxDate,
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
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      }
    }
  }
  // Hide the keyboard when tapping outside of text fields
  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // Method to show dialog messages
  void _showDialog(String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Fond blanc
          title: Text(
            isError ? 'Erreur' : 'Succès',
            style: TextStyle(color: Colors.black), // Texte coloré
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black), // Texte coloré
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF6A96CE)), // Texte du bouton coloré
              ),
            ),
          ],
        );
      },
    );
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
                // Affichage du loader si _isLoading est vrai
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6887B0)),
                    ),
                  ),
                // Image sélectionnée ou image par défaut
                if (!_isLoading)
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
                  maxLines: 1, // Limite le titre à une seule ligne
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Donnez un titre à votre action',
                    hintStyle: const TextStyle(color: Color(0xFF2F313F)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis, // Ajoute "..." en cas de dépassement
                  ),
                ),

                const SizedBox(height: 20),
                // Description input field as a multi-line textarea
                TextField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5, // Allows the textarea to expand up to 5 lines
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Donnez une description à votre action',
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
                const SizedBox(height: 10),
                // Localisation input field
                TextField(
                  controller: _localisationController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Localisation',
                    labelStyle: const TextStyle(color: Color(0xFF2F313F)),
                    hintText: 'Où aura lieu l\'action?',
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
                // Date de début
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
                const SizedBox(height: 10),
                // Date de fin
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
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final currentUser = await _getCurrentUserData();
                      final actionId = uuid.v4();

                      await ActionService().createAction(
                        actionId: actionId,
                        titre: _titreController.text,
                        description: _descriptionController.text,
                        localisation: _localisationController.text,
                        debut: _debutController.text,
                        fin: _finController.text,
                        besoin: _besoinController.text,
                        telephone: '$_selectedCountryCode ${_telephoneController.text}',
                        imageFile: _selectedImage,
                        userId: currentUser['userId'],
                        firstName: currentUser['firstName'],
                        lastName: currentUser['lastName'],
                        profilePic: currentUser['profilePic'],
                      );

                      _clearFields();
                      _showDialog('Action créée avec succès !');
                    } catch (error) {
                      _showDialog('Une erreur est survenue : $error', isError: true);
                    } finally {
                    setState(() {
                    _isLoading = false;
                    });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Proposer une action',
                    style: TextStyle(color: Color(0xFF2F313F)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}