import 'package:cito_act_mobile_app/views/action_buttons_section.dart';
import 'package:cito_act_mobile_app/views/add_button.dart';
import 'package:cito_act_mobile_app/views/user_info_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/profile_edit_popup.dart';
import '../models/user_model.dart'; // Importer votre modèle utilisateur

class ProfilPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProfilPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Assurez-vous que la collection est correcte
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // L'icône dans l'AppBar
            onPressed: currentUser != null // Vérification avant de passer currentUser
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileEditPopup(user: currentUser!); // Passez l'utilisateur ici
                },
              );
            }
                : null, // Ne rien faire si currentUser est nul
          ),

          // Ajouter l'image à droite de l'icône si elle existe
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: currentUser?.imageUrl != null
                  ? NetworkImage(currentUser!.imageUrl!) // Image de profil de l'utilisateur
                  : const AssetImage("assets/images/profile.jpg") as ImageProvider, // Image par défaut
              radius: 20,
            ),
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator()) // Afficher un loader si les données ne sont pas encore chargées
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSection(user: currentUser!), // Passer les infos de l'utilisateur
            ActionButtonsSection(context),
            AddButton(),
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
