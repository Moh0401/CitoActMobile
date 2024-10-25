import 'package:cito_act_mobile_app/models/projet_model.dart';
import 'package:cito_act_mobile_app/services/projet_service.dart';
import 'package:cito_act_mobile_app/views/projet_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/action_model.dart';
import '../services/action_service.dart';

class MesProjetsPage extends StatefulWidget {
  final String userId;

  MesProjetsPage({
    required this.userId,

  });

  @override
  _MesProjetsPageState createState() => _MesProjetsPageState();
}

class _MesProjetsPageState extends State<MesProjetsPage> {
  final ProjetService _projetService = ProjetService();
  late Future<List<ProjetModel>> _projetsFuture;

  @override
  void initState() {
    super.initState();
    print("Initializing MesActionPage with userId: ${widget.userId}"); // Log pour déboguer
    _projetsFuture = _projetService.getValidatedActionsByUser(widget.userId);
    _projetsFuture.then((actions) {
      print("Actions récupérées: ${actions.length}"); // Log pour déboguer
    }).catchError((error) {
      print("Erreur lors de la récupération des actions: $error"); // Log pour déboguer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MES PROJETS',
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
      body: FutureBuilder<List<ProjetModel>>(
        future: _projetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des projets: ${snapshot.error}')); // Afficher l'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun projet validée trouvée.'));
          }

          final actions = snapshot.data!;
          print("Nombre de projets affichées: ${actions.length}"); // Log pour déboguer

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF6887B0), // Couleur de la bordure
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.titre,
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
                              action.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(
                              action.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjetDetailPage(
                                      projetId: action.projetId,  // Passer l'ID du projet
                                      groupName: action.titre, // Le nom du groupe (ou autre paramètre pertinent)
                                      selectedIndex: 0,  // L'index sélectionné, initialisez-le à une valeur par défaut
                                      onItemTapped: (index) {}, // Placeholder pour la fonction de changement de page
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white),
                                backgroundColor: Colors.transparent,
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
              );
            },
          );
        },
      ),
    );
  }
}