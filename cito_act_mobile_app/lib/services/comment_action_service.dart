import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cito_act_mobile_app/models/comment_action_model.dart';

class CommentActionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer les commentaires pour une action donnée
  Future<List<CommentActionModel>> fetchComments(String actionId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('comments_actions')
          .where('actionId', isEqualTo: actionId)
          .get();

      List<CommentActionModel> comments = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']; // Récupérer l'ID de l'utilisateur

        // Récupérer les informations de l'utilisateur
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        var userData = userDoc.data() as Map<String, dynamic>;

        comments.add(CommentActionModel(
          commentId: doc.id,
          actionId: data['actionId'],
          userId: userId,
          firstName: userData['firstName'], // Récupérer le prénom de l'utilisateur
          lastName: userData['lastName'], // Récupérer le nom de l'utilisateur
          content: data['content'],
          timestamp: data['timestamp'],
        ));
      }

      return comments;
    } catch (e) {
      throw Exception('Échec de la récupération des commentaires: $e');
    }
  }

  // Ajouter un nouveau commentaire
  Future<void> addComment(CommentActionModel comment) async {
    try {
      await _firestore.collection('comments_actions').add(comment.toMap());
    } catch (e) {
      throw Exception('Échec de l\'ajout du commentaire: $e');
    }
  }
}