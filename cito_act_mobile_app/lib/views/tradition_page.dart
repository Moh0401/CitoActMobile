import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'tradition_detail_page.dart';
import '../models/tradition_model.dart'; // Assurez-vous d'importer le bon modèle

class TraditionPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  TraditionPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Traditions', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomSearchBar(),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('traditions')
                    .where('valider', isEqualTo: true) // Filtrer par valider = true
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Une erreur est survenue'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Aucune tradition trouvée'));
                  }

                  // Récupérer les données des documents
                  List<TraditionModel> traditions = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return TraditionModel.fromMap(data); // Utiliser le factory pour créer TraditionModel
                  }).toList();

                  return ListView.builder(
                    itemCount: traditions.length,
                    itemBuilder: (context, index) {
                      return buildCard(context, traditions[index]);
                    },
                  );
                },
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

  Widget buildCard(BuildContext context, TraditionModel tradition) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: tradition.imageUrl != null
            ? Image.network(tradition.imageUrl!, fit: BoxFit.cover, width: 80) // Utiliser imageUrl
            : Container(width: 80, color: Colors.grey[300]), // Placeholder si pas d'image
        title: Text(tradition.titre.toUpperCase(),
    maxLines: 1, // Limite le titre à une seule ligne
    style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          tradition.description,
          maxLines: 3, // Limiter à 3 lignes
          overflow: TextOverflow.ellipsis, // Ajouter des points de suspension si le texte dépasse
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TraditionDetailPage(
                  tradition: tradition,
                  selectedIndex: selectedIndex,
                  onItemTapped: onItemTapped,
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