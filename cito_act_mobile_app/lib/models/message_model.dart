class ChatMessage {
  String messageId;
  String senderId;
  String groupId;  // Nouvelle propriété
  String senderName;
  String message;
  DateTime timestamp;
  bool isParrain;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.groupId,  // Ajout du groupId
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isParrain = false, // Permet de distinguer un parrain d'un utilisateur
  });

  // Conversion de l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'groupId': groupId, // Ajoute cette ligne
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isParrain': isParrain,
    };
  }

  // Créer un ChatMessage à partir d'un Map Firestore
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'],
      senderId: map['senderId'],
      groupId: map['groupId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      isParrain: map['isParrain'] ?? false,
    );
  }
}
