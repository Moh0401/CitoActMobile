import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> createUser(UserModel user) async {
    try {
      print("Ajout de l'utilisateur avec UID : ${user.uid}");
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'phone': user.phone,
        'role': user.role,
        'imageUrl': user.imageUrl,
      });
      print("Utilisateur ajouté avec succès dans Firestore.");
    } catch (e) {
      print("Erreur lors de l'ajout de l'utilisateur dans Firestore : $e");
    }
  }

  }


