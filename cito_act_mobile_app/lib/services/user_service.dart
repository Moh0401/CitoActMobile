import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  // Récupérer les données de l'utilisateur actuel
  Future<Map<String, dynamic>> getCurrentUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await usersRef.doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données utilisateur: $e');
    }
  }
}
