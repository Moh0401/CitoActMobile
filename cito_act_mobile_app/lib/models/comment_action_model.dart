import 'package:cloud_firestore/cloud_firestore.dart';

class CommentActionModel {
  String id; // Ajout du champ id
  String userId;
  String text;
  DateTime timestamp;
  String imageUrl;
  String firstName;
  String lastName;
  bool isReported;
  String actionId;

  CommentActionModel({
    required this.id, // Inclure id dans le constructeur
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    this.isReported = false,
    required this.actionId,
  });

  factory CommentActionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CommentActionModel(
      id: documentId, // Passer l'ID du document ici
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      isReported: map['isReported'] ?? false,
      actionId: map['actionId'] ?? '',
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
      'actionId': actionId,
    };
  }
}
