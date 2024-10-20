import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cito_act_mobile_app/models/user_model.dart';
import 'package:cito_act_mobile_app/services/auth_service.dart';
import 'package:cito_act_mobile_app/services/firestore_service.dart';
import 'package:cito_act_mobile_app/services/storage_service.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  File? _selectedImage;
  String? _webImageUrl;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        final reader = html.FileReader();
        reader.readAsDataUrl(input.files!.first);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _webImageUrl = reader.result as String;
          });
        });
      });
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? userModel = await _authService.signUpWithEmail(
        emailController.text,
        passwordController.text,
      );

      if (userModel != null) {
        String imageUrl = '';

        if (_selectedImage != null) {
          imageUrl =
              await _storageService.uploadImage(_selectedImage!, userModel.uid);
        }

        if (imageUrl.isEmpty) {
          print("Erreur lors du téléchargement de l'image.");
          return;
        }

        UserModel newUser = UserModel(
          uid: userModel.uid,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          role: 'citoyen',
          imageUrl: imageUrl,
        );

        await _firestoreService.createUser(newUser);
        print("Utilisateur créé dans Firestore avec succès !");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Votre compte a été créé avec succès !'),
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print("Échec de la création de l'utilisateur");
      }
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création du compte.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _getImageProvider(),
                    backgroundColor: Color(0xFF6887B0),
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField(firstNameController, 'Prénom'),
                const SizedBox(height: 16),
                buildTextField(lastNameController, 'Nom'),
                const SizedBox(height: 16),
                buildTextField(emailController, 'Email'),
                const SizedBox(height: 16),
                buildTextField(phoneController, 'Tél'),
                const SizedBox(height: 16),
                buildTextField(passwordController, 'Mot de passe',
                    isPassword: true),
                const SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6887B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Lien pour l'inscription
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Connectez-vous',
                    style: TextStyle(
                      color: Color(0xFF6887B0), // Texte bleu
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (kIsWeb && _webImageUrl != null) {
      return NetworkImage(_webImageUrl!);
    } else if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    return null;
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF6887B0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFF6887B0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFF6887B0)),
        ),
      ),
    );
  }
}
