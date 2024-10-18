import 'package:cito_act_mobile_app/views/comment_projet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour Firestore
import '../models/projet_model.dart';
import '../services/projet_service.dart';
import '../utils/bottom_nav_bar.dart';
import 'chat_screen.dart';

class ProjetDetailPage extends StatefulWidget {
  final String projetId;
  final String groupName;
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProjetDetailPage({
    required this.projetId,
    required this.groupName,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _ProjetDetailPageState createState() => _ProjetDetailPageState();
}

class _ProjetDetailPageState extends State<ProjetDetailPage> {
  bool _isLiked = false; // État pour gérer si le projet est liké
  int _likesCount = 0;   // État pour le nombre de likes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projets')
            .doc(widget.projetId)
            .snapshots(), // Écouter les changements en temps réel
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Aucun projet trouvé.'));
          }

          // Récupérer les données du projet
          var projetData = snapshot.data!.data() as Map<String, dynamic>;
          final projet = ProjetModel.fromMap(projetData);
          _likesCount = projet.likes ?? 0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Image en arrière-plan
                    Image.network(
                      projet.imageUrl,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                    // Bouton de retour
                    Positioned(
                      left: 16.0,
                      top: 32.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white,),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(projet.profilePic),
                            radius: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${projet.firstName} ${projet.lastName}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        projet.titre.toUpperCase(),
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
                      Text(
                        'Localisation: ${projet.localisation}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Début: ${projet.debut}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Fin: ${projet.fin}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Besoin: ${projet.besoin}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Téléphone: ${projet.telephone}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      // Carte FlutterMap
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {

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
                            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                              // Incrémenter les likes si l'utilisateur aime le projet
                              if (_isLiked) {
                                ProjetService().incrementLikes(projet.projetId, projet.likes ?? 0);
                              }
                            },
                          ),
                          Text('$_likesCount LIKE'), // Affichage dynamique du nombre de likes
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CommentProjetPage()),
                              );
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
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }
}