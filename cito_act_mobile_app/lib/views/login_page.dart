import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart'; // Assurez-vous que le chemin d'importation est correct

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false; // État pour le loader

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo en haut
            Image.asset(
              "assets/images/login_logo.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),

            // Champ de texte pour l'email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Color(0xFF6887B0), // Couleur du label
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6887B0), width: 2.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Champ de texte pour le mot de passe
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                  color: Color(0xFF6887B0), // Couleur du label
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6887B0), width: 2.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Affichage du loader ou du bouton de connexion
            if (_isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6887B0)), // Couleur du loader
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true; // Démarre le loader
                    });
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    UserModel? user = await _authService.signInWithEmailAndPassword(email, password);
                    setState(() {
                      _isLoading = false; // Arrête le loader
                    });
                    if (user != null) {
                      // Connexion réussie
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vous êtes authentifié avec succès !'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pushNamed(context, '/after-login');
                    } else {
                      // Afficher une alerte
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Échec de la connexion')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6887B0), // Couleur du bouton
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Texte en blanc
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Lien pour l'inscription
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                'Pas encore de compte ? Inscrivez-vous',
                style: TextStyle(
                  color: Color(0xFF6887B0), // Texte bleu
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
