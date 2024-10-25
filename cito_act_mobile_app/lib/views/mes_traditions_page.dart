import 'package:cito_act_mobile_app/models/projet_model.dart';
import 'package:cito_act_mobile_app/models/tradition_model.dart';
import 'package:cito_act_mobile_app/services/projet_service.dart';
import 'package:cito_act_mobile_app/services/tradition_service.dart';
import 'package:cito_act_mobile_app/views/tradition_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/action_model.dart';
import '../services/action_service.dart';

class MesTraditionsPage extends StatefulWidget {
  final String userId;
  final int selectedIndex;
  final Function(int) onItemTapped;
  MesTraditionsPage({
    required this.userId,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _MesTraditionsPageState createState() => _MesTraditionsPageState();
}

class _MesTraditionsPageState extends State<MesTraditionsPage> {
  final TraditionService _traditionService = TraditionService();
  late Future<List<TraditionModel>> _traditionsFuture;

  @override
  void initState() {
    super.initState();
    print("Initializing MesActionPage with userId: ${widget.userId}"); // Log pour déboguer
    _traditionsFuture = _traditionService.getValidatedTraditionsByUser(widget.userId);
    _traditionsFuture.then((actions) {
      print("Traditions récupérées: ${actions.length}"); // Log pour déboguer
    }).catchError((error) {
      print("Erreur lors de la récupération des traditions: $error"); // Log pour déboguer
    });
  }

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
      body: FutureBuilder<List<TraditionModel>>(
        future: _traditionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des traditions: ${snapshot.error}')); // Afficher l'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune tradition validée trouvée.'));
          }

          final actions = snapshot.data!;
          print("Nombre de traditions affichées: ${actions.length}"); // Log pour déboguer

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: actions.length, // Remplacer `traditions` par `actions`
            itemBuilder: (context, index) {
              final tradition = actions[index]; // Remplacer `traditions[index]` par `actions[index]`

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF6887B0),
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
                      tradition.titre,
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
                            tradition.imageUrl != null
                                ? Image.network(
                              tradition.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey, // Ou une image par défaut
                              child: Icon(Icons.image_not_supported), // Icône pour indiquer qu'il n'y a pas d'image
                            ),

                            SizedBox(height: 8),
                            Text(
                              tradition.description,
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
                                    builder: (context) => TraditionDetailPage(
                                      tradition: tradition,
                                      selectedIndex: widget.selectedIndex, // Utilisez widget.selectedIndex ici
                                      onItemTapped: widget.onItemTapped,   // Utilisez widget.onItemTapped ici
                                    ),
                                  ),
                                );                              },
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