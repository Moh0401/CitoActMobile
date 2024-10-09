import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget { // Changement de nom ici
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Hauteur de la barre de recherche
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding horizontal
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6887B0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center, // Centre verticalement
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5), // Ajustement du padding
                ),
              ),
            ),
          ),
          Icon(Icons.search, color: Color(0xFF6887B0), size: 20), // Taille d'icône réduite
        ],
      ),
    );
  }
}
