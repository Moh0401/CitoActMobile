import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreenProjet extends StatefulWidget {
  final String chatGroupId;

  const ChatScreenProjet({Key? key, required this.chatGroupId}) : super(key: key);

  @override
  _ChatScreenProjetState createState() => _ChatScreenProjetState();
}

class _ChatScreenProjetState extends State<ChatScreenProjet> {
  TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Liste pour stocker les messages
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> members = [];
  List<Map<String, dynamic>> parrains = [];


  @override
  void initState() {
    super.initState();
    // Récupérer les messages dès le démarrage
    fetchMessages();
    fetchMembersAndParrains();
  }

  Future<void> fetchMembersAndParrains() async {
    // Récupérer les membres
    _firestore
        .collection('chats')
        .doc(widget.chatGroupId)
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        members = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    });

    // Récupérer les parrains
    _firestore
        .collection('parrainages')
        .doc(widget.chatGroupId)
        .collection('parrains')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> parrainsList = [];
      for (var doc in snapshot.docs) {
        String userId = doc['userId'];
        // Récupérer les informations de l'utilisateur
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          parrainsList.add({
            'firstName': userData['firstName'],
            'lastName': userData['lastName'],
            'userId': userId,
          });
        }
      }
      setState(() {
        parrains = parrainsList;
      });
    });
  }

  // Fonction pour récupérer les messages de Firestore
  Future<void> fetchMessages() async {
    _firestore.collection('chats')
        .doc(widget.chatGroupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        messages = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    });
  }

  // Fonction pour envoyer un message
  Future<void> sendMessage() async {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      final user = _auth.currentUser;
      if (user != null) {
        // Récupérer le prénom et le nom de l'utilisateur
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        String firstName = userDoc['firstName'] ?? 'Inconnu';
        String lastName = userDoc['lastName'] ?? 'Inconnu';

        // Envoyer le message à Firestore
        await _firestore.collection('chats')
            .doc(widget.chatGroupId)
            .collection('messages')
            .add({
          'message': message,
          'firstName': firstName,
          'lastName': lastName,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        messageController.clear(); // Effacer le champ de texte
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Projet"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.group),
            color: Colors.white, // Fond blanc pour le popup
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Membres:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF6887B0),
                        )
                    ),
                    ...members.map((member) => Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6887B0), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${member['firstName']} ${member['lastName']}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    )),
                    SizedBox(height: 8),
                    Divider(color: Color(0xFF6887B0)),
                    Text(
                        'Parrains:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF6887B0),
                        )
                    ),
                    ...parrains.map((parrain) => Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF6887B0), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${parrain['firstName']} ${parrain['lastName']}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15), // Marges gauche et droite de 5
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF6887B0), width: 2), // Bordure
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Texte aligné à gauche
                    children: [
                      Text(
                        '${msg['firstName']} ${msg['lastName']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(msg['message']),
                      SizedBox(height: 5),
                      Text(
                        msg['timestamp']?.toDate().toString() ?? '',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage, // Envoyer un message
                  icon: Icon(Icons.send, color: Color(0xFF6887B0)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
