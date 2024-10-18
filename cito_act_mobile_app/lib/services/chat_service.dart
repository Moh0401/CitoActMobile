import 'package:cito_act_mobile_app/models/chat_group.dart';
import 'package:cito_act_mobile_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour créer un groupe de chat
  Future<void> createChatGroup(String actionId, List<String> userIds, List<String> parrainIds) async {
    String groupId = _firestore.collection('chat_groups').doc().id;

    ChatGroup chatGroup = ChatGroup(
      groupId: groupId,
      actionId: actionId,
      participantIds: userIds,
      parrainIds: parrainIds,
      createdAt: DateTime.now(),
      messageIds: [], // Nouvelle propriété pour stocker les IDs des messages
    );

    await _firestore.collection('chat_groups').doc(groupId).set(chatGroup.toMap());
  }

  // Méthode pour rejoindre un groupe de chat (ajout d'un utilisateur à un groupe)
  Future<void> joinGroup(String groupId, String userId) async {
    DocumentReference groupRef = _firestore.collection('chat_groups').doc(groupId);

    // Ajouter l'utilisateur à la liste des participants si pas déjà présent
    await groupRef.update({
      'participantIds': FieldValue.arrayUnion([userId]),
    });
  }

  // Méthode pour devenir parrain d'une action (ajout en tant que parrain)
  Future<void> becomeParrain(String groupId, String userId) async {
    DocumentReference groupRef = _firestore.collection('chat_groups').doc(groupId);

    // Ajouter l'utilisateur à la liste des parrains s'il n'y est pas déjà
    await groupRef.update({
      'parrainIds': FieldValue.arrayUnion([userId]),
      'participantIds': FieldValue.arrayUnion([userId]), // Ajoute aussi aux participants
    });
  }

  // Méthode pour récupérer les détails du groupe de chat
  Future<ChatGroup> getChatGroup(String actionId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('chat_groups')
        .where('actionId', isEqualTo: actionId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ChatGroup.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } else {
      throw Exception('Groupe de chat non trouvé');
    }
  }

  // Envoyer un message dans un groupe de chat
  Future<void> sendMessage(String groupId, String senderId, String senderName, String message, bool isParrain) async {
    String messageId = const Uuid().v4();

    ChatMessage chatMessage = ChatMessage(
      messageId: messageId,
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
      isParrain: isParrain,
    );

    try {
      // Ajouter le message à la collection 'messages'
      await _firestore.collection('messages').doc(messageId).set(chatMessage.toMap());

      // Mettre à jour le groupe avec l'ID du nouveau message
      await _firestore.collection('chat_groups').doc(groupId).update({
        'messageIds': FieldValue.arrayUnion([messageId])
      });
    } catch (e) {
      print('Erreur lors de l\'ajout du message dans Firestore: $e'); // Affiche l'erreur ici aussi
      throw e; // Laisse l'erreur remonter pour être gérée dans la méthode appelante
    }
  }

  // Récupérer les messages d'un groupe de chat en temps réel
  Stream<List<ChatMessage>> getMessages(String groupId) {
    return _firestore
        .collection('messages')
        .where('groupId', isEqualTo: groupId)  // Filtrer par le groupId
        .orderBy('timestamp', descending: false)  // Trier par timestamp (du plus ancien au plus récent)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

}