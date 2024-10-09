import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
      print("Utilisateur ajouté à Firestore avec succès.");
    } catch (e) {
      print("Erreur lors de l'ajout de l'utilisateur à Firestore : $e");
    }
  }
}
