import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/comment_action_model.dart';
import '../services/comment_action_service.dart';

class CommentActionPage extends StatefulWidget {
  final String actionId;

  CommentActionPage({required this.actionId});

  @override
  _CommentActionPageState createState() => _CommentActionPageState();
}

class _CommentActionPageState extends State<CommentActionPage> {
  final List<CommentActionModel> comments = [];
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instance de Firestore

  // Remplacez par les informations de l'utilisateur actuel
  final String currentUserFirstName = 'Prénom';
  final String currentUserLastName = 'Nom';

  final CommentActionService _commentService = CommentActionService();

  @override
  void initState() {
    super.initState();
    _fetchComments(); // Appel de la méthode privée
  }

  Future<List<CommentActionModel>> _fetchComments() async { // Méthode renommée
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('comments_actions')
          .where('actionId', isEqualTo: widget.actionId)
          .get();

      List<CommentActionModel> comments = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']; // Récupérer l'ID de l'utilisateur

        // Récupérer les informations de l'utilisateur
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          print('User Data: $userData'); // Imprimez les données de l'utilisateur

          comments.add(CommentActionModel(
            commentId: doc.id,
            actionId: data['actionId'],
            userId: userId,
            firstName: userData['firstName'] ?? 'Inconnu', // Défaut si non trouvé
            lastName: userData['lastName'] ?? 'Inconnu',
            content: data['content'],
            timestamp: data['timestamp'],
          ));
        } else {
          print('User document does not exist for userId: $userId');
        }
      }

      return comments;
    } catch (e) {
      throw Exception('Échec de la récupération des commentaires: $e');
    }
  }

  Future<void> _addComment() async {
    if (_controller.text.isNotEmpty) {
      // Récupérer l'utilisateur connecté via Firebase Auth
      final currentUser = FirebaseAuth.instance.currentUser;
      final userId = currentUser?.uid; // Récupérer l'ID de l'utilisateur connecté

      if (userId != null) {
        // Récupérer les informations de l'utilisateur depuis Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;

          // Récupérer le prénom et le nom de l'utilisateur
          String firstName = userData['firstName'] ?? 'Inconnu';
          String lastName = userData['lastName'] ?? 'Inconnu';

          // Créer le commentaire avec les bonnes informations
          final newComment = CommentActionModel(
            commentId: '', // Firestore générera un ID
            actionId: widget.actionId,
            userId: userId, // Utiliser l'ID de l'utilisateur connecté
            firstName: firstName,
            lastName: lastName,
            content: _controller.text,
            timestamp: DateTime.now().toString(),
          );

          try {
            // Ajouter le commentaire dans Firestore
            await _commentService.addComment(newComment);

            // Mettre à jour la liste des commentaires dans l'interface utilisateur
            setState(() {
              comments.add(newComment);
              _controller.clear();
            });
          } catch (e) {
            print("Erreur lors de l'ajout du commentaire: $e");
          }
        } else {
          print("Le document utilisateur n'existe pas pour l'ID: $userId");
        }
      } else {
        print("Utilisateur non connecté.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Commentaires')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${comments[index].firstName} ${comments[index].lastName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comments[index].content),
                      Text(comments[index].timestamp, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}