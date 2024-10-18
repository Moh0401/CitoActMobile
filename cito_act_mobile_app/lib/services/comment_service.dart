import 'package:cito_act_mobile_app/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentTraditionService {
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection('comments_traditions');

  // Ajouter un commentaire
  Future<void> addComment(CommentTraditionModel comment) async {
    await commentsRef.add(comment.toMap());
  }

  // Récupérer les commentaires
  Stream<List<CommentTraditionModel>> getComments() {
    return commentsRef.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CommentTraditionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
