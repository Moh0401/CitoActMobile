class CommentActionModel {
  String commentId;
  String actionId;
  String userId; // Nouveau champ pour l'ID de l'utilisateur
  String firstName;
  String lastName;
  String content;
  String timestamp;

  CommentActionModel({
    required this.commentId,
    required this.actionId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'actionId': actionId,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory CommentActionModel.fromMap(Map<String, dynamic> map) {
    return CommentActionModel(
      commentId: map['commentId'],
      actionId: map['actionId'],
      userId: map['userId'], // Assurez-vous que ce champ existe
      firstName: map['firstName'],
      lastName: map['lastName'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}