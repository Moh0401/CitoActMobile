import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              "assets/images/login_logo.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: passwordController,
              labelText: 'Mot de passe',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading ? _buildLoader() : _buildLoginButton(context),
            const SizedBox(height: 20),
            _buildSignUpLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF6887B0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6887B0), width: 2.0),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  Widget _buildLoader() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6887B0)),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          String email = emailController.text.trim();
          String password = passwordController.text.trim();
          UserModel? user = await _authService.signInWithEmailAndPassword(email, password);

          setState(() {
            _isLoading = false;
          });

          if (user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Vous êtes authentifié avec succès !'),
                duration: Duration(seconds: 1),
              ),
            );
            await Future.delayed(Duration(seconds: 1));

            // Redirection basée sur le rôle de l'utilisateur
            if (user.role == 'ong') {
              Navigator.pushNamed(context, '/home'); // Redirige les ONG vers /home
            } else {
              Navigator.pushNamed(context, '/after-login'); // Redirige les autres vers /after-login
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Échec de la connexion')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6887B0),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Se connecter',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/signupSelection');
      },
      child: Text(
        'Pas encore de compte ? Inscrivez-vous',
        style: TextStyle(color: Color(0xFF6887B0)),
      ),
    );
  }
}