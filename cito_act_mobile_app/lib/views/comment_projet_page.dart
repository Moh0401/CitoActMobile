import 'package:cito_act_mobile_app/models/comment_model.dart';
import 'package:cito_act_mobile_app/models/comment_projet_model.dart';
import 'package:cito_act_mobile_app/services/comment_projet_service.dart';
import 'package:cito_act_mobile_app/services/comment_service.dart';
import 'package:cito_act_mobile_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentProjetPage extends StatefulWidget {
  @override
  _CommentProjetPageState createState() => _CommentProjetPageState();
}

class _CommentProjetPageState extends State<CommentProjetPage> {
  final CommentProjetService _commentProjetService = CommentProjetService();
  final UserService _userService = UserService(); // Service pour récupérer les informations de l'utilisateur
  final TextEditingController _commentController = TextEditingController();

  // Variables pour stocker les informations utilisateur
  String? _imageUrl;
  String? _firstName;
  String? _lastName;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Charger les données de l'utilisateur
  }

  void _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser
        ?.uid; // Obtenir l'ID utilisateur actuel

    if (userId != null) {
      try {
        // Remplacez cette ligne
        final userData = await _userService.getCurrentUserData(
            userId); // Passer userId en paramètre
        setState(() {
          _imageUrl = userData['imageUrl'];
          _firstName = userData['firstName'];
          _lastName = userData['lastName'];
        });
      } catch (e) {
        // Gérer les erreurs (afficher un message, etc.)
        print('Erreur de récupération des données utilisateur: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires'),
        backgroundColor: Color(0xFF6887B0), // Couleur de fond de la barre d'applications
      ),
      body: Container(
        color: Colors.white, // Couleur de fond blanche
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<CommentProjetModel>>(
                stream: _commentProjetService.getComments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Couleur de fond pour le commentaire
                          border: Border.all(color: Color(0xFF6887B0), width: 2), // Bordure de couleur
                          borderRadius: BorderRadius.circular(8.0), // Arrondi des coins
                        ),
                        child: ListTile(
                          title: Text(comment.text),
                          subtitle: Text('Posté par: ${comment.firstName} ${comment.lastName}'),
                          trailing: Text(comment.timestamp.toLocal().toString()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Ajouter un commentaire...',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6887B0), width: 2.0), // Bordure de couleur lorsque le champ est focalisé
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      final newComment = CommentProjetModel(
                        userId: 'user_id_example', // Remplacer par l'ID utilisateur actuel
                        text: _commentController.text,
                        timestamp: DateTime.now(),
                        imageUrl: _imageUrl ?? '', // Récupérer l'image URL
                        firstName: _firstName ?? '', // Récupérer le prénom
                        lastName: _lastName ?? '', // Récupérer le nom
                      );
                      await _commentProjetService.addComment(newComment);
                      _commentController.clear(); // Vider le champ de texte après envoi
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
