import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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

      // Sauvegarder l'action dans Firestore
      await _firestore.collection('actions').doc(actionId).set(action.toMap());

      // Créer un groupe de chat pour l'action avec les utilisateurs et les parrains
      // Créer le groupe de chat pour ce projet
      await createChatGroupForAction(actionId);
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

  // Méthode pour récupérer les actions validées
  Future<List<ActionModel>> getValidatedActions() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('actions')
          .where('valider', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => ActionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des actions : $e');
    }
  }

  // Méthode pour "liker" une action
  Future<void> likeAction(String actionId, String userId) async {
    DocumentReference actionRef = _firestore.collection('actions').doc(actionId);
    DocumentReference likeRef = actionRef.collection('likes').doc(userId);

    // Vérifier si l'utilisateur a déjà liké l'action
    DocumentSnapshot likeSnapshot = await likeRef.get();
    if (likeSnapshot.exists) {
      // Si l'utilisateur a déjà liké, on retire le like
      await likeRef.delete();
      await actionRef.update({
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      // Sinon, on ajoute le like
      await likeRef.set({'userId': userId});
      await actionRef.update({
        'likeCount': FieldValue.increment(1),
      });
    }
  }

  // Méthode pour vérifier si l'utilisateur a déjà liké une action
  Future<bool> hasLikedAction(String actionId, String userId) async {
    DocumentReference likeRef = _firestore.collection('actions').doc(actionId).collection('likes').doc(userId);
    DocumentSnapshot likeSnapshot = await likeRef.get();
    return likeSnapshot.exists;
  }

  Future<List<ActionModel>> getValidatedActionsByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('actions')
          .where('valider', isEqualTo: true) // Filtrer par actions validées
          .where('userId', isEqualTo: userId) // Filtrer par l'utilisateur
          .get();

      return snapshot.docs.map((doc) => ActionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des actions validées : $e');
    }
  }

  Future<void> createChatGroupForAction(String actionId) async {
    try {
      // Générer un ID unique pour le groupe de chat
      String chatGroupId = const Uuid().v4();

      // Mettre à jour le projet avec l'ID du groupe de chat
      await _firestore.collection('actions').doc(actionId).update({
        'chatGroupId': chatGroupId,
      });

      // Créer le groupe de chat dans une collection dédiée
      await _firestore.collection('chats').doc(chatGroupId).set({
        'actionId': actionId,
        'createdAt': FieldValue.serverTimestamp(),
        'messages': [], // Initialisation avec une liste de messages vide
      });

    } catch (e) {
      throw Exception('Erreur lors de la création du groupe de chat: $e');
    }
  }



}