import 'package:cito_act_mobile_app/models/comment_action_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentActionService {
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection('comments');

  Future<void> addComment(CommentActionModel comment, String actionId) async {
    try {
      comment.actionId = actionId; // Assurez-vous d'avoir l'actionId
      DocumentReference docRef = await commentsRef.add(comment.toMap());

      // Récupérer l'ID généré par Firestore et mettre à jour le commentaire
      comment.id = docRef.id;
      await docRef.update({'id': comment.id});  // Mettez à jour le commentaire avec l'ID

      print("Comment successfully added with ID: ${comment.id} and isReported: ${comment.isReported}");
    } catch (e) {
      print("Failed to add comment: $e");
    }
  }



  Stream<List<CommentActionModel>> getCommentsForAction(String actionId) {
    return commentsRef
        .where('actionId', isEqualTo: actionId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        return CommentActionModel.fromMap(data, doc.id); // Passer doc.id ici
      } else {
        throw Exception('Comment data is null');
      }
    }).toList());
  }




  Future<void> reportComment(String commentId) async {
    try {
      // Met à jour le champ isReported du commentaire avec l'ID fourni
      await commentsRef.doc(commentId).update({'isReported': true});
    } catch (e) {
      print("Failed to report comment: $e");
      throw e; // Renvoyer l'erreur pour la gérer à un niveau supérieur si nécessaire
    }
  }
}
