import 'package:cito_act_mobile_app/models/projet_model.dart';
import 'package:cito_act_mobile_app/views/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'projet_detail_page.dart';

class ProjetPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProjetPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<ProjetPage> createState() => _ProjetPageState();
}

class _ProjetPageState extends State<ProjetPage> {

  List<ProjetModel> _allProjets = [];
  List<ProjetModel> _filteredProjets = [];

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProjets = _allProjets;
      } else {
        _filteredProjets = _allProjets.where((projet) {
          return projet.titre.toLowerCase().contains(query.toLowerCase()) ;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String groupName = 'Nom du Groupe'; // Définissez ici le nom du groupe

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Projets', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Naviguer vers la page des notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(onSearch: _onSearch),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('projets')
                    .where('valider', isEqualTo: true) // Filtrer les projets validés
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Une erreur est survenue'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Aucun projet trouvé'));
                  }

                  // Récupérer les données des documents
                  List<ProjetModel> projets = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return ProjetModel.fromMap(data); // Utiliser le factory pour créer ProjetModel
                  }).toList();

                  return ListView.builder(
                    itemCount: projets.length,
                    itemBuilder: (context, index) {
                      return buildCard(context, projets[index], groupName);
                    },
                  );
                },
              )

            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }

  Widget buildCard(BuildContext context, ProjetModel projet, String groupName) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: projet.imageUrl.isNotEmpty
            ? Image.network(projet.imageUrl, fit: BoxFit.cover, width: 80) // Utiliser imageUrl
            : Container(width: 80, color: Colors.grey[300]), // Placeholder si pas d'image
        title: Text(
          projet.titre.toUpperCase(),
          maxLines: 1, // Limite le titre à une seule ligne
          style: TextStyle(fontWeight: FontWeight.bold), // Utiliser titre
        ),
        subtitle: Text(
          projet.description,
          maxLines: 3, // Limiter à 3 lignes
          overflow: TextOverflow.ellipsis, // Ajouter des points de suspension si le texte dépasse
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjetDetailPage(
                  projetId: projet.projetId, // Passez l'ID du projet ici
                  groupName: groupName, // Passez groupName ici
                  selectedIndex: widget.selectedIndex,
                  onItemTapped: widget.onItemTapped,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            side: BorderSide(color: Color(0xFF6887B0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text('Voir', style: TextStyle(color: Color(0xFF6887B0))),
        ),
      ),
    );
  }
}