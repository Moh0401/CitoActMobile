import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'action_detail_page.dart';
import '../models/action_model.dart';
import '../services/action_service.dart';

class ActionPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userId; // ID de l'utilisateur
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur

  ActionPage({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  @override
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final ActionService _actionService = ActionService();
  late Future<List<ActionModel>> _actionsFuture;

  @override
  void initState() {
    super.initState();
    _actionsFuture = _actionService.getValidatedActions(); // Récupérer les actions validées
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Actions', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomSearchBar(),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ActionModel>>(
                future: _actionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune action validée trouvée.'));
                  }

                  // Afficher la liste des actions validées
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final action = snapshot.data![index];
                      return buildCard(context, action);
                    },
                  );
                },
              ),
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

  Widget buildCard(BuildContext context, ActionModel action) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.network(action.imageUrl, fit: BoxFit.cover, width: 80),
        title: Text(action.titre, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(action.description),
        trailing: TextButton(
          onPressed: () {
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
