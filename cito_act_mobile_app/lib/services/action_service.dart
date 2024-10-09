import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/action_model.dart';

class ActionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour créer une nouvelle action et uploader une image sur Firebase Storage
  Future<void> createAction({
    required String actionId,
    required String titre,
    required String description,
    required String localisation,
    required String debut,
    required String fin,
    required String besoin,
    required String telephone,
    required XFile? imageFile,
    required String userId,
    required String firstName,
    required String lastName,
    required String profilePic,
  }) async {
    try {
      // Upload de l'image si fournie
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImageToFirebase(actionId, File(imageFile.path));
      }

      // Créer l'objet ActionModel avec "valider" défini à false
      ActionModel action = ActionModel(
        actionId: actionId,
        titre: titre,
        description: description,
        localisation: localisation,
        debut: debut,
        fin: fin,
        besoin: besoin,
        telephone: telephone,
        imageUrl: imageUrl,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        profilePic: profilePic,
        valider: false, // Ajout du champ valider
      );

      // Sauvegarde de l'action dans Firestore
      await _firestore.collection('actions').doc(actionId).set(action.toMap());
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'action : $e');
    }
  }

  // Méthode pour uploader l'image dans Firebase Storage
  Future<String> _uploadImageToFirebase(String actionId, File imageFile) async {
    final Reference storageRef = _storage.ref().child('action_images/$actionId');
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
