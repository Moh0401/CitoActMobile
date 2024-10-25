import 'package:cito_act_mobile_app/models/comment_action_model.dart';
import 'package:cito_act_mobile_app/models/comment_tradition_model.dart';
import 'package:cito_act_mobile_app/models/comment_projet_model.dart';
import 'package:cito_act_mobile_app/services/comment_action_service.dart';
import 'package:cito_act_mobile_app/services/comment_projet_service.dart';
import 'package:cito_act_mobile_app/services/comment_tradition_service.dart';
import 'package:cito_act_mobile_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentTraditionPage extends StatefulWidget {
  final String TraditionId; // Ajout du projetId

  CommentTraditionPage({required this.TraditionId}); // Recevoir le projetId

  @override
  _CommentTraditionPageState createState() => _CommentTraditionPageState();
}



class _CommentTraditionPageState extends State<CommentTraditionPage> {
  final CommentTraditionService _commentTraditionService = CommentTraditionService();
  final UserService _userService = UserService();
  final TextEditingController _commentController = TextEditingController();

  // Variables pour stocker les informations utilisateur
  String? _imageUrl;
  String? _firstName;
  String? _lastName;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Charger les données de l'utilisateur
  }

  void _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        final userData = await _userService.getCurrentUserData(userId);
        setState(() {
          _imageUrl = userData['imageUrl'];
          _firstName = userData['firstName'];
          _lastName = userData['lastName'];
        });
      } catch (e) {
        print('Erreur de récupération des données utilisateur: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF6887B0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<CommentTraditionModel>>(
                stream: _commentTraditionService.getCommentsForAction(widget.TraditionId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('Erreur: ${snapshot.error}');
                    return Center(child: Text('Erreur lors du chargement des commentaires'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun commentaire pour le moment'));
                  }

                  final comments = snapshot.data!;

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF6887B0), width: 2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: comment.imageUrl.isNotEmpty
                                ? NetworkImage(comment.imageUrl)
                                : AssetImage('assets/default_avatar.png') as ImageProvider,
                            backgroundColor: Colors.grey,
                          ),
                          title: Text(comment.text),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Posté par: ${comment.firstName} ${comment.lastName}'),
                              if (comment.isReported)
                                Text('Signalé', style: TextStyle(color: Color(0xFF6887B0))),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  comment.isReported ? Icons.flag_outlined : Icons.flag,
                                  color: comment.isReported ? Color(0xFF6887B0) : Colors.grey,
                                ),
                                onPressed: comment.isReported ? null : () async {
                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmer le signalement'),
                                        content: Text('Voulez-vous vraiment signaler ce commentaire ?'),
                                        actions: <Widget>[
                                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Annuler')),
                                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Confirmer')),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    try {
                                      await _commentTraditionService.reportComment(comment.id); // Utiliser l'ID du commentaire
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Commentaire signalé')));
                                      setState(() {
                                        comment.isReported = true;
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors du signalement'), backgroundColor: Color(0xFF6887B0)));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Ajouter un commentaire...',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6887B0), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (_commentController.text.isNotEmpty) {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          final comment = CommentTraditionModel(
                            id: '', // L'ID sera généré automatiquement
                            text: _commentController.text,
                            userId: userId,
                            firstName: _firstName ?? '',
                            lastName: _lastName ?? '',
                            imageUrl: _imageUrl ?? '',
                            isReported: false,
                            timestamp: DateTime.now(),
                           traditionId: widget.TraditionId,
                          );
                          await _commentTraditionService.addComment(comment, widget.TraditionId);
                          _commentController.clear();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
