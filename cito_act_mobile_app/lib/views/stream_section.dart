import 'package:cito_act_mobile_app/models/projet_model.dart';
import 'package:cito_act_mobile_app/models/tradition_model.dart';
import 'package:cito_act_mobile_app/views/action_detail_page.dart';
import 'package:cito_act_mobile_app/views/custom_card.dart';
import 'package:cito_act_mobile_app/views/projet_detail_page.dart';
import 'package:cito_act_mobile_app/views/tradition_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/action_model.dart'; // Assurez-vous d'importer ActionModel

class StreamSection extends StatelessWidget {
  final String title;
  final String collection;
  final String userId; // ID de l'utilisateur
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur

  StreamSection({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.collection,
  });

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
            child: StreamBuilder<QuerySnapshot>(
              // Filtrer les documents avec valider à true
              stream: FirebaseFirestore.instance
                  .collection(collection)
                  .where('valider', isEqualTo: true) // Ajout du filtre ici
                  .snapshots(),
              builder: (context, snapshot) {
                // Vérification de l'état de connexion
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Vérification de la présence de données
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucune donnée trouvée.'));
                }

                // Liste des cartes à afficher
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                    return CustomCard(
                      imageUrl: data['imageUrl'] ?? 'assets/images/default.jpg',
                      title: data['titre'] ?? 'Sans titre',
                      description: data['description'] ?? 'Pas de description disponible',
                      onTapDetails: () {
                        if (collection == 'actions') {
                          ActionModel action = ActionModel(
                            actionId: doc.id,
                            titre: data['titre'],
                            description: data['description'],
                            imageUrl: data['imageUrl'],
                            profilePic: data['profilePic'],
                            firstName: data['firstName'],
                            lastName: data['lastName'],
                            localisation: data['localisation'],
                            debut: data['debut'],
                            fin: data['fin'],
                            besoin: data['besoin'],
                            telephone: data['telephone'],
                            userId: data['userId'],
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActionDetailPage(
                                userId: userId, // ID de l'utilisateur
                                firstName: firstName, // Utilisation de widget.firstName
                                lastName: lastName, // Utilisation de widget.lastName
                                action: action,
                                selectedIndex: 0,
                                onItemTapped: (index) {
                                  // Logique pour changer l'index sélectionné si nécessaire
                                },
                              ),
                            ),
                          );
                        } else if (collection == 'projets') {
                          ProjetModel projet = ProjetModel(
                            projetId: doc.id,
                            titre: data['titre'],
                            description: data['description'],
                            imageUrl: data['imageUrl'],
                            profilePic: data['profilePic'],
                            firstName: data['firstName'],
                            lastName: data['lastName'],
                            localisation: data['localisation'],
                            debut: data['debut'],
                            fin: data['fin'],
                            besoin: data['besoin'],
                            telephone: data['telephone'],
                            userId: data['userId'],
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjetDetailPage(
                                projetId: projet.projetId,
                                groupName: '',
                                selectedIndex: 0,
                                onItemTapped: (index) {
                                  // Logique pour changer l'index sélectionné si nécessaire
                                },
                              ),
                            ),
                          );
                        } else if (collection == 'traditions') {
                          TraditionModel tradition = TraditionModel(
                            id: doc.id,
                            titre: data['titre'],
                            description: data['description'],
                            imageUrl: data['imageUrl'],
                            profilePic: data['profilePic'],
                            firstName: data['firstName'],
                            lastName: data['lastName'],
                            videoUrl: data['videoUrl'],
                            audioUrl: data['audioUrl'],
                            documentUrl: data['documentUrl'],
                            praticiens: data['praticiens'],
                            menaces: data['menaces'],
                            origine: data['origine'],
                            userId: data['userId'],
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TraditionDetailPage(
                                tradition: tradition,
                                selectedIndex: 0,
                                onItemTapped: (index) {
                                  // Logique pour changer l'index sélectionné si nécessaire
                                },
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
