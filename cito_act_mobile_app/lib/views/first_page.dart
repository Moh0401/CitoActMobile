import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Aligner en haut
          children: [
            const SizedBox(height: 100), // Espacement en haut
            // Container for logo and title
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/login_logo.png", // Assurez-vous que ce chemin est correct
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenue sur CitoAct',
                    style: TextStyle(
                      fontSize: 24, // Taille du texte pour le titre
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Espace qui pousse le contenu vers le haut
            // Button with borderRadius
            Container(
              alignment: Alignment.center, // Centrer le bouton
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/login'); // Naviguer vers la page de connexion
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Ajustez le radius si nécessaire
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20, // Réduit la taille verticale du bouton
                    horizontal: 20, // Réduit la taille horizontale du bouton
                  ),
                  backgroundColor: const Color(0xFF6887B0), // Couleur de fond
                ),
                child: const Icon(
                  Icons.arrow_forward, // Icône à l'intérieur du bouton
                  size: 50, // Réduisez la taille de l'icône
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
            ),
            const SizedBox(height: 50), // Espacement en bas
          ],
        ),
      ),
    );
  }
}
