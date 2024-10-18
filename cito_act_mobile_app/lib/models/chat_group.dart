class ChatGroup {
  String groupId;
  String actionId;
  List<String> participantIds; // IDs des utilisateurs et parrains
  List<String> parrainIds; // Liste des IDs de parrains
  DateTime createdAt;
  List<String> messageIds;


  ChatGroup({
    required this.groupId,
    required this.actionId,
    required this.participantIds,
    required this.parrainIds,
    required this.createdAt,
    required this.messageIds,

  });

  // Conversion en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'actionId': actionId,
      'participantIds': participantIds,
      'parrainIds': parrainIds,
      'createdAt': createdAt.toIso8601String(),
      'messageIds': messageIds, // Ajout de messageIds
    };
  }

  // Création à partir d'un Map Firestore
  factory ChatGroup.fromMap(Map<String, dynamic> map) {
    return ChatGroup(
      groupId: map['groupId'],
      actionId: map['actionId'],
      participantIds: List<String>.from(map['participantIds']),
      parrainIds: List<String>.from(map['parrainIds']),
      createdAt: DateTime.parse(map['createdAt']),
      messageIds: List<String>.from(map['messageIds'] ?? []), // Ajout de messageIds avec une valeur par défaut
    );
  }
}
