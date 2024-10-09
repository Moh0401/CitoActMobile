import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/projet.dart';
import '../utils/bottom_nav_bar.dart';
import 'groupe_page.dart';
 // Assurez-vous d'importer la page de groupe

class ProjetDetailPage extends StatelessWidget {
  final Projet projet;
  final String groupName; // Nouveau champ pour le nom du groupe
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProjetDetailPage({
    required this.projet,
    required this.groupName, // Passer le nom du groupe ici
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              projet.imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projet.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6887B0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    projet.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  // Ajout de la carte FlutterMap à la place de l'image
                  Container(
                    height: 300, // Ajuster la hauteur selon les besoins
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(12.6392, -8.0029), // Coordonnées de Bamako
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(12.6392, -8.0029),
                              width: 80.0,
                              height: 80.0,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupPage(groupName: groupName), // Navigation vers GroupPage
                            ),
                          );
                        },
                        child: Text('ADHERER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6887B0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('PARRAINER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6887B0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      Text('LIKE'),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {},
                      ),
                      Text('COMMENTAIRE'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
