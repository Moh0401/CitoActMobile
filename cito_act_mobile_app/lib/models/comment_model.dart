class CommentTraditionModel {
  final String userId;
  final String text;
  final DateTime timestamp;
  final String imageUrl; // Ajout de l'image URL
  final String firstName; // Ajout du prénom
  final String lastName; // Ajout du nom

  CommentTraditionModel({
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.imageUrl, // Ajout
    required this.firstName, // Ajout
    required this.lastName, // Ajout
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl, // Ajout
      'firstName': firstName, // Ajout
      'lastName': lastName, // Ajout
    };
  }

  factory CommentTraditionModel.fromMap(Map<String, dynamic> map) {
    return CommentTraditionModel(
      userId: map['userId'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
      imageUrl: map['imageUrl'], // Ajout
      firstName: map['firstName'], // Ajout
      lastName: map['lastName'], // Ajout
    );
  }
}
