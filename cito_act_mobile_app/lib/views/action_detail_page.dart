import 'package:cito_act_mobile_app/services/action_service.dart';
import 'package:cito_act_mobile_app/services/chat_service.dart';
import 'package:cito_act_mobile_app/views/comment_action_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Assurez-vous d'importer latlong2
import '../models/action_model.dart'; // Assurez-vous d'importer votre ActionModel ici
import '../utils/bottom_nav_bar.dart';
import 'chat_screen.dart'; // Importer la nouvelle page

class ActionDetailPage extends StatefulWidget {
  final ActionModel action; // Changer ActionItem en ActionModel
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userId; // ID de l'utilisateur
  final String firstName; // Prénom de l'utilisateur
  final String lastName; // Nom de l'utilisateur

  ActionDetailPage({
    required this.action,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  @override
  _ActionDetailPageState createState() => _ActionDetailPageState();
}

class _ActionDetailPageState extends State<ActionDetailPage> {
  int likeCount = 0;
  bool isLiked = false;
  final ActionService _actionService = ActionService();
  final ChatService _chatService = ChatService();


  // Méthode pour ajouter l'utilisateur au groupe


  @override
  void initState() {
    super.initState();
    // Initialiser le nombre de likes et vérifier si l'utilisateur a liké
    likeCount = widget.action.likeCount;
    _checkIfLiked();
  }

  // Vérifier si l'utilisateur a déjà liké
  void _checkIfLiked() async {
    String userId = 'USER_ID'; // Remplacez par l'ID de l'utilisateur actuel
    bool liked = await _actionService.hasLikedAction(widget.action.actionId, userId);
    setState(() {
      isLiked = liked;
    });
  }

  // Méthode pour gérer le like
  void toggleLike() async {
    String userId = 'USER_ID'; // Remplacez par l'ID de l'utilisateur actuel
    await _actionService.likeAction(widget.action.actionId, userId);

    setState(() {
      if (isLiked) {
        likeCount--;
        isLiked = false;
      } else {
        likeCount++;
        isLiked = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permet à l'image d'aller sous l'AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparent
        elevation: 0, // Pas d'ombre sous l'AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Icône de retour blanche
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image en haut de la page, recouvrant la zone de l'AppBar
            Image.network(
              widget.action.imageUrl, // Utilisez imageUrl de ActionModel
              fit: BoxFit.cover,
              height: 300, // Hauteur augmentée pour que l'image couvre le haut
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300, // Ajusté pour garder la hauteur
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Center(child: Text('Image non disponible')),
                );
              },
            ),

            // Informations de l'utilisateur (nom, prénom, photo de profil)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Image de profil de l'utilisateur
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.action.profilePic), // Image de profil de l'utilisateur
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                  ),
                  SizedBox(width: 16),

                  // Nom et prénom de l'utilisateur
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.action.firstName} ${widget.action.lastName}', // Affiche prénom et nom
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Organisateur', // Vous pouvez personnaliser ce texte
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Titre de l'action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.action.titre.toUpperCase(), // Utilisez titre de ActionModel
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6887B0),
                ),
              ),
            ),
            SizedBox(height: 8),

            // Description de l'action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.action.description, // Utilisez description de ActionModel
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 16),

            // Informations supplémentaires (localisation, début, fin, besoin, téléphone)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Localisation
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        widget.action.localisation, // Localisation de l'action
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Date de début et de fin
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Du ${widget.action.debut} au ${widget.action.fin}', // Dates de début et de fin
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Besoin
                  Row(
                    children: [
                      Icon(Icons.list_alt, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Besoin: ${widget.action.besoin}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis, // Gère le débordement
                          maxLines: 2, // Limite à deux lignes
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Téléphone
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Contact: ${widget.action.telephone}', // Téléphone de l'organisateur
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Carte en bas de la page
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(12.6392, -8.0029), // Coordonnées de Bamako
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(12.6392, -8.0029),
                        width: 80.0,
                        height: 80.0,
                        child: Icon(
                          Icons.location_pin,
                          color: Color(0xFF6887B0),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Boutons d'action en bas de la carte
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Récupérer l'utilisateur connecté
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String userId = user.uid; // ID de l'utilisateur actuel
                      String actionId = widget.action.actionId; // ID de l'action liée au groupe de chat

                      // Vérifiez si le groupe existe déjà
                      bool groupExists = false;
                      try {
                        await _chatService.getChatGroup(actionId);
                        groupExists = true;
                      } catch (e) {
                        // Le groupe n'existe pas encore
                        groupExists = false;
                      }

                      if (!groupExists) {
                        // Si le groupe n'existe pas, créez-le
                        List<String> userIds = [userId]; // Les participants initiaux (l'utilisateur actuel)
                        List<String> parrainIds = []; // Ajoutez ici les ID de parrain si nécessaire
                        await _chatService.createChatGroup(actionId, userIds, parrainIds);
                      }

                      // Ajouter l'utilisateur au groupe (s'il n'est pas déjà dans le groupe)
                      await _actionService.joinGroup(widget.action.actionId, userId);

                      // Rediriger vers la page de chat du groupe
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            groupId: widget.action.actionId, // Utilisation de widget.action
                            userId: userId, // ID de l'utilisateur
                            firstName: widget.firstName, // Utilisation de widget.firstName
                            lastName: widget.lastName, // Utilisation de widget.lastName
                          ),
                        ),
                      );
                    } else {
                      // Gérer le cas où l'utilisateur n'est pas connecté (afficher un message d'erreur ou rediriger)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez vous connecter pour adhérer à cette action.')),
                      );
                    }
                  },
                  child: Text('ADHERER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6887B0),
                    foregroundColor: Colors.white,
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    // Récupérer l'utilisateur connecté
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String userId = user.uid; // ID de l'utilisateur actuel
                      String actionId = widget.action.actionId; // ID de l'action liée au groupe de chat

                      // Vérifiez si le groupe existe déjà
                      bool groupExists = false;
                      try {
                        await _chatService.getChatGroup(actionId);
                        groupExists = true;
                      } catch (e) {
                        groupExists = false; // Le groupe n'existe pas
                      }

                      if (groupExists) {
                        // Si le groupe existe déjà, définir l'utilisateur comme parrain
                        await _actionService.becomeParrain(actionId, userId);

                        // Afficher un message de succès
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vous êtes maintenant un parrain pour ce groupe.')),
                        );
                      } else {
                        // Si le groupe n'existe pas encore, afficher un message d'erreur ou en créer un (selon le besoin)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Le groupe de discussion n\'existe pas encore.')),
                        );
                      }
                    } else {
                      // Gérer le cas où l'utilisateur n'est pas connecté (afficher un message d'erreur)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez vous connecter pour parrainer cette action.')),
                      );
                    }
                  },
                  child: Text('PARRAINER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6887B0),
                    foregroundColor: Colors.white,
                  ),
                ),


              ],
            ),
            SizedBox(height: 16),

            // Boutons "LIKE" et "COMMENTAIRE"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Color(0xFF6887B0) : null,
                  ),
                  onPressed: toggleLike,
                ),
                Text('$likeCount'),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentActionPage(actionId: widget.action.actionId), // Ajoutez la parenthèse fermante ici
                      ),
                    );
                  },
                ),


              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }
}
