import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
// Import de la barre de navigation

class AcceuilPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  AcceuilPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Section(title: 'ACTION', imagePrefix: 'action'),
            Section(title: 'PROJET', imagePrefix: 'projet'),
            Section(title: 'TRADITION', imagePrefix: 'tradition'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex, // Passage de l'index sélectionné
        onItemTapped: onItemTapped,   // Passage de la fonction de tap
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String imagePrefix; // Nouveau paramètre pour le préfixe d'image

  Section({required this.title, required this.imagePrefix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6887B0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 250, // Hauteur des cartes
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                CustomCard(imagePath: 'assets/images/${imagePrefix}1.jpg', title: '${title} 1'),
                CustomCard(imagePath: 'assets/images/${imagePrefix}2.jpg', title: '${title} 2'),
                CustomCard(imagePath: 'assets/images/${imagePrefix}3.jpg', title: '${title} 3'),
                CustomCard(imagePath: 'assets/images/${imagePrefix}4.jpg', title: '${title} 4'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;

  CustomCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? (screenWidth * 0.75).toDouble() : 200.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: cardWidth, // Largeur dynamique de chaque carte
        decoration: BoxDecoration(
          color: Color(0xFF6887B0),
          borderRadius: BorderRadius.circular(10), // Radius uniforme pour la carte
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Radius uniforme pour l'image et le contenu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 100, // Hauteur fixe de l'image
                width: cardWidth, // Largeur dynamique
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white, // Couleur du texte en blanc
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white, // Couleur du texte en blanc
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 36.0,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, // Couleur du texte du bouton
                      side: BorderSide(color: Colors.white), // Bordure blanche
                      backgroundColor: Colors.transparent, // Fond transparent
                    ),
                    child: Text('Voir Détails'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
