import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/tradition_model.dart';

class TraditionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour créer une tradition
  Future<void> createTradition(
      TraditionModel tradition,
      File? imageFile,
      File? videoFile,
      File? documentFile,
      String? audioPath,
      ) async {
    try {
      // Récupérer les informations de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(tradition.userId).get();

      // Vérifier si l'utilisateur existe et récupérer l'image de profil
      String profilePic = userDoc['imageUrl'] ?? '';

      // Créer la tradition en ajoutant l'image de profil de l'utilisateur
      DocumentReference traditionRef = await _firestore.collection('traditions').add({
        'titre': tradition.titre,
        'description': tradition.description,
        'userId': tradition.userId,
        'firstName': tradition.firstName,
        'lastName': tradition.lastName,
        'profilePic': profilePic, // Ajouter l'image de profil de l'utilisateur
        // Ajoutez d'autres champs si nécessaire
      });

      // Uploader l'image si elle existe
      if (imageFile != null) {
        String imageUrl = await _uploadFile('tradition_images/${traditionRef.id}', imageFile);
        traditionRef.update({'imageUrl': imageUrl});
      }

      // Uploader la vidéo si elle existe
      if (videoFile != null) {
        String videoUrl = await _uploadFile('tradition_videos/${traditionRef.id}', videoFile);
        traditionRef.update({'videoUrl': videoUrl});
      }

      // Uploader le document si il existe
      if (documentFile != null) {
        String documentUrl = await _uploadFile('tradition_documents/${traditionRef.id}', documentFile);
        traditionRef.update({'documentUrl': documentUrl});
      }

      // Uploader l'audio si il existe
      if (audioPath != null) {
        String audioUrl = await _uploadFile('tradition_audios/${traditionRef.id}', File(audioPath));
        traditionRef.update({'audioUrl': audioUrl});
      }
    } catch (e) {
      throw Exception("Erreur lors de la création de la tradition : $e");
    }
  }

  // Méthode pour uploader un fichier sur Firebase Storage
  Future<String> _uploadFile(String path, File file) async {
    try {
      // Uploader le fichier et obtenir un lien de téléchargement
      TaskSnapshot snapshot = await _storage.ref(path).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Erreur lors de l'upload du fichier : $e");
    }
  }

  Future<void> incrementLikes(String traditionId, int currentLikes) async {
    // Incrémentez le nombre de likes dans Firestore
    await _firestore.collection('traditions').doc(traditionId).update({
      'likes': currentLikes + 1,
    });
  }

}
