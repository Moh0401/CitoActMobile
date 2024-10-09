import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String uid) async {
    try {
      final ref = _storage
          .ref()
          .child('user_images/$uid/${image.path.split('/').last}');
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl; // Retourne l'URL de l'image
    } catch (e) {
      print("Erreur lors du téléchargement de l'image : $e");
      return ''; // Retourne une chaîne vide en cas d'échec
    }
  }
}
