import 'package:flutter/material.dart';
import 'package:cito_act_mobile_app/models/message_model.dart';
import 'package:cito_act_mobile_app/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String userId;
  final String firstName;
  final String lastName;

  ChatScreen({required this.groupId, required this.userId, required this.firstName, required this.lastName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ensureUserInGroup();
  }

  Future<void> _ensureUserInGroup() async {
    try {
      await chatService.joinGroup(widget.groupId, widget.userId);
    } catch (e) {
      print('Erreur lors de la tentative de rejoindre le groupe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: Impossible de rejoindre le groupe de discussion.')),
      );
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final String messageText = _messageController.text;
      final String senderName = '${widget.firstName} ${widget.lastName}';

      try {
        await chatService.sendMessage(
          widget.groupId,
          widget.userId,
          senderName,
          messageText,
          false,
        );
        _messageController.clear();
      } catch (e) {
        print('Erreur lors de l\'envoi du message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: Le message n\'a pas pu être envoyé.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Groupe de Chat', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatService.getMessages(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Erreur lors de la récupération des messages: ${snapshot.error}');
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun message pour l\'instant.'));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.senderName,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                              SizedBox(height: 4),
                              Text(message.message),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}