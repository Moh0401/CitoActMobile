import 'dart:io';
import 'package:cito_act_mobile_app/models/projet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';



class ProjetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to create a new action and upload an image to Firebase Storage
  Future<void> createProjet({
    required String projetId,
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
      // Upload the image if provided
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImageToFirebase(projetId, File(imageFile.path));
      }

      // Create ActionModel object
      ProjetModel projet = ProjetModel(
        projetId: projetId,
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

      // Save action to Firestore
      await _firestore.collection('projets').doc(projetId).set(projet.toMap());
    } catch (e) {
      throw Exception('Failed to create projet: $e');
    }
  }

  // Helper method to upload an image to Firebase Storage
  Future<String> _uploadImageToFirebase(String projetId, File imageFile) async {
    try {
      final ref = _storage.ref().child('action_images/$projetId/${imageFile.path.split('/').last}');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Method to fetch all actions
  Future<List<ProjetModel>> fetchActions() async {
    try {
      final snapshot = await _firestore.collection('actions').get();
      return snapshot.docs.map((doc) => ProjetModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch actions: $e');
    }
  }

  // Method to delete an action
  Future<void> deleteAction(String actionId) async {
    try {
      await _firestore.collection('actions').doc(actionId).delete();
    } catch (e) {
      throw Exception('Failed to delete action: $e');
    }
  }
}

