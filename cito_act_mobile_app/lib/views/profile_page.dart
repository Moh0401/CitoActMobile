import 'package:cito_act_mobile_app/models/ong_model.dart';
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
  dynamic currentUser; // Changement ici de UserModel? à dynamic

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            if (data['role'] == 'ong') {
              currentUser = UserOngModel.fromMap(data); // Enlever le cast
            } else {
              currentUser = UserModel.fromMap(data);
            }
          });
        } else {
          print('Document utilisateur introuvable');
        }
      } catch (e) {
        print('Erreur lors du chargement des données utilisateur : $e');
      }
    } else {
      print('Aucun utilisateur connecté');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Remplacez '/login' par votre route de page de connexion
  }

  @override
  Widget build(BuildContext context) {
    bool isOng = currentUser is UserOngModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: currentUser != null
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileEditPopup(user: currentUser);
                },
              );
            }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: currentUser?.imageUrl != null
                  ? NetworkImage(currentUser.imageUrl)
                  : const AssetImage("assets/images/profile.jpg") as ImageProvider,
              radius: 20,
            ),
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSection(user: currentUser),
            ActionButtonsSection(
              context,
              userId: currentUser.uid,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isOng) ...[
                  AddButton(),
                  const SizedBox(width: 20),
                ],
                const SizedBox(width: 20),
                SizedBox(
                  width: 90,
                  height: 90,
                  child: IconButton(
                    icon: Icon(Icons.logout, color: Color(0xFF6887B0)),
                    iconSize: 36,
                    onPressed: logout,
                  ),
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
