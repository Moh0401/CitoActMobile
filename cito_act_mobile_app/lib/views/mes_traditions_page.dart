import 'package:flutter/material.dart';

class MesTraditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MES TRADITIONS',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF6887B0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF6887B0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tradition Proposée Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF6887B0), // Couleur de la bordure
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tradition proposée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6887B0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.network(
                            'https://example.com/image_projet_propose.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'LOREM IPSUM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi.',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/projet_details');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, // Couleur du texte
                              side: BorderSide(color: Colors.white), // Bordure blanche
                              backgroundColor: Colors.transparent, // Fond transparent
                            ),
                            child: Text('Voir Détails'),
                          ),
                        ],
                      ),
                    ),
                    color: Color(0xFF6887B0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Tradition Adhérée Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF6887B0), // Couleur de la bordure
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tradition Adhérée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6887B0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.network(
                            'https://example.com/image_projet_adhere.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'LOREM IPSUM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi.',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/projet_details');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, // Couleur du texte
                              side: BorderSide(color: Colors.white), // Bordure blanche
                              backgroundColor: Colors.transparent, // Fond transparent
                            ),
                            child: Text('Voir Détails'),
                          ),
                        ],
                      ),
                    ),
                    color: Color(0xFF6887B0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
