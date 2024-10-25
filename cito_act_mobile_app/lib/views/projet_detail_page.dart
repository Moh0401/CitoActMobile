import 'package:cito_act_mobile_app/views/chat_screen_projet.dart';
import 'package:cito_act_mobile_app/views/comment_projet_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour Firestore
import '../models/projet_model.dart';
import '../services/projet_service.dart';
import '../utils/bottom_nav_bar.dart';

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
  bool _isParrain = false; // État pour gérer si l'utilisateur est parrain


  // Fonction pour gérer le parrainage
  Future<void> parrainProjet() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez être connecté pour parrainer un projet.")),
      );
      return;
    }

    try {
      // Vérifier si l'utilisateur est déjà parrain
      final parrainageDoc = await FirebaseFirestore.instance
          .collection('parrainages')
          .doc(widget.projetId)
          .collection('parrains')
          .doc(user.uid)
          .get();

      if (parrainageDoc.exists) {
        setState(() {
          _isParrain = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vous êtes déjà le parrain de ce projet.")),
        );
      } else {
        // Enregistrer le parrainage dans Firestore
        await FirebaseFirestore.instance
            .collection('parrainages')
            .doc(widget.projetId)
            .collection('parrains')
            .doc(user.uid)
            .set({
          'userId': user.uid,
          'projetId': widget.projetId,
          'parrainéLe': Timestamp.now(),
        });

        setState(() {
          _isParrain = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vous êtes maintenant parrain de ce projet.")),
        );
      }
    } catch (e) {
      print("Erreur lors du parrainage : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du parrainage.")),
      );
    }
  }

  // Fonction pour adhérer au groupe de chat
  Future<void> adhereAuGroupe() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vous devez être connecté pour adhérer au groupe.")),
      );
      return;
    }

    try {
      // Récupérer les données de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Assurez-vous que ce nom de collection est correct
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        String firstName = userData['firstName'] ?? 'Inconnu';
        String lastName = userData['lastName'] ?? 'Inconnu';

        // Ajouter l'utilisateur au groupe de chat
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.projetId) // Utiliser l'ID du groupe de chat approprié
            .collection('users')
            .doc(user.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'joinedAt': Timestamp.now(),
        });

        // Rediriger l'utilisateur vers la page de chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreenProjet(
              chatGroupId: widget.projetId, // Passer l'ID du groupe de chat ici
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Données de l'utilisateur introuvables.")),
        );
      }
    } catch (e) {
      print("Erreur lors de l'adhésion au groupe : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'adhésion au groupe.")),
      );
    }
  }




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
                                    color: Color(0xFF6887B0),
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
                            onPressed: adhereAuGroupe, // Appel de la méthode pour adhérer
                            child: Text('ADHERER'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6887B0),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: parrainProjet, // Appel de la méthode pour parrainer
                            child: Text(_isParrain ? 'Déjà Parrainé' : 'PARRAINER'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6887B0),
                              foregroundColor: Colors.white,                            ),
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
                                MaterialPageRoute(
                                  builder: (context) => CommentProjetPage(projetId: widget.projetId), // Passer l'ID du projet ici
                                ),
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