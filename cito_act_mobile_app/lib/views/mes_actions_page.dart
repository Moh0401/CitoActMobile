import 'package:cito_act_mobile_app/views/action_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/action_model.dart';
import '../services/action_service.dart';

class MesActionPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userId;
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur
  MesActionPage({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  @override
  _MesActionPageState createState() => _MesActionPageState();
}

class _MesActionPageState extends State<MesActionPage> {
  final ActionService _actionService = ActionService();
  late Future<List<ActionModel>> _actionsFuture;

  @override
  void initState() {
    super.initState();
    print("Initializing MesActionPage with userId: ${widget.userId}"); // Log pour déboguer
    _actionsFuture = _actionService.getValidatedActionsByUser(widget.userId);
    _actionsFuture.then((actions) {
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
          'MES ACTIONS',
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
      body: FutureBuilder<List<ActionModel>>(
        future: _actionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des actions: ${snapshot.error}')); // Afficher l'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune action validée trouvée.'));
          }

          final actions = snapshot.data!;
          print("Nombre d'actions affichées: ${actions.length}"); // Log pour déboguer

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
                                // Naviguer vers les détails de l'action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActionDetailPage(
                                      userId: widget.userId, // ID de l'utilisateur
                                      firstName: widget.firstName, // Utilisation de widget.firstName
                                      lastName: widget.lastName, // Utilisation de widget.lastName
                                      action: action,
                                      selectedIndex: widget.selectedIndex,
                                      onItemTapped: widget.onItemTapped,
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