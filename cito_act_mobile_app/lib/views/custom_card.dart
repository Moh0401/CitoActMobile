import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onTapDetails; // Ajout d'une fonction de callback

  CustomCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTapDetails, // Ajout du paramètre onTapDetails
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? (screenWidth * 0.75).toDouble() : 200.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Color(0xFF6887B0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                height: 100,
                width: cardWidth,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 100,
                width: cardWidth,
                color: Colors.grey,
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 36.0,
                  child: OutlinedButton(
                    onPressed: onTapDetails, // Ajout de la fonction onTapDetails ici
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                      backgroundColor: Colors.transparent,
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
