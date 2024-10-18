import 'package:cito_act_mobile_app/models/comment_projet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CommentProjetService {
  final CollectionReference commentsRef = FirebaseFirestore.instance.collection('comments_projets');

  // Ajouter un commentaire
  Future<void> addComment(CommentProjetModel comment) async {
    await commentsRef.add(comment.toMap());
  }

  // Récupérer les commentaires
  Stream<List<CommentProjetModel>> getComments() {
    return commentsRef.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CommentProjetModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
