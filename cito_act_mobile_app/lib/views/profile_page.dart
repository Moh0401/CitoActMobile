import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/profile_edit_popup.dart';
import '../utils/proposer_action_popup.dart';
import '../utils/proposer_popup.dart';
import '../utils/proposer_projet_popup.dart';
import '../utils/proposer_tradition_popup.dart';

class ProfilPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProfilPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // L'icône dans l'AppBar
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileEditPopup(); // Affiche le popup de modification
                },
              );
            },
          ),

          // Ajouter l'image à droite de l'icône
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"), // Remplacer par votre image
              radius: 20, // Ajuster la taille du cercle
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoSection(),
            ActionButtonsSection(context),
            AddButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Infos Utilisateurs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildInfoRow('ID', '001'),
          _buildInfoRow('Nom', 'Traoré'),
          _buildInfoRow('Prénom', 'Mohamed'),
          _buildInfoRow('Email', 'mohamed@gmail.com'),
          _buildInfoRow('Tél', '+223 76435578'),
          _buildInfoRow('Role', 'Citoyen'),
          _buildInfoRow('Date D\'inscription', '01/01/2000'),
          _buildInfoRow('Point De Participation', '2000'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label : ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class ActionButtonsSection extends StatelessWidget {
  final BuildContext context;

  ActionButtonsSection(this.context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildButton(context, 'MES ACTIONS', () {
            Navigator.of(context).pop(); // Ferme le pop-up
            Navigator.pushNamed(context, '/mes-actions'); // Redirige vers la page des actions
          }),
          SizedBox(height: 10),
          _buildButton(context, 'MES PROJETS', () {
            Navigator.of(context).pop(); // Ferme le pop-up
            Navigator.pushNamed(context, '/mes-projets'); // Redirige vers la page des projets
          }),
          SizedBox(height: 10),
          _buildButton(context, 'TRADITIONS PARTAGÉS', () {
            Navigator.of(context).pop(); // Ferme le pop-up
            Navigator.pushNamed(context, '/traditions-partages'); // Redirige vers la page des traditions
          }),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Color(0xFF6887B0),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            // Affiche le popup ProposerPopup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProposerPopup(); // Appel du popup pour proposer une action, un projet ou une tradition
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white), // Icône en blanc
          backgroundColor: Color(0xFF6887B0),
        ),
      ),
    );
  }
}

