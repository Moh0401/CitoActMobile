import 'package:cloud_firestore/cloud_firestore.dart';

class CommentTraditionModel {
  String id; // Ajout du champ id
  String userId;
  String text;
  DateTime timestamp;
  String imageUrl;
  String firstName;
  String lastName;
  bool isReported;
  String traditionId;

  CommentTraditionModel({
    required this.id, // Inclure id dans le constructeur
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    this.isReported = false,
    required this.traditionId,
  });

  factory CommentTraditionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CommentTraditionModel(
      id: documentId, // Passer l'ID du document ici
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      isReported: map['isReported'] ?? false,
      traditionId: map['traditionId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'isReported': isReported,
      'traditionId': traditionId,
    };
  }
}
