import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Assurez-vous d'importer latlong2
import '../models/action.dart';
import '../utils/bottom_nav_bar.dart';
import 'groupe_page.dart'; // Importer la nouvelle page

class ActionDetailPage extends StatelessWidget {
  final ActionItem action;
  final int selectedIndex;
  final Function(int) onItemTapped;

  ActionDetailPage({
    required this.action,
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
            Image.network(
              action.imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(child: Text('Image non disponible')),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6887B0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    action.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),

                  // Carte en bas de la page
                  Container(
                    height: 300,
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

                  // Boutons d'action en bas de la carte
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Naviguer vers la page du groupe
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupPage(groupName: action.title),
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
                        onPressed: () {
                          // Ajoutez votre logique pour "PARRAINER"
                        },
                        child: Text('PARRAINER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6887B0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Boutons "LIKE" et "COMMENTAIRE"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          // Ajoutez votre logique pour "LIKE"
                        },
                      ),
                      Text('LIKE'),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          // Ajoutez votre logique pour "COMMENTAIRE"
                        },
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
