import 'package:cito_act_mobile_app/views/mes_actions_page.dart';
import 'package:cito_act_mobile_app/views/mes_projets_page.dart';
import 'package:cito_act_mobile_app/views/mes_traditions_page.dart';
import 'package:flutter/material.dart';

class ActionButtonsSection extends StatelessWidget {
  final BuildContext context;
  final String userId; // Ajoutez ceci

  ActionButtonsSection(this.context, {required this.userId}); // Modifiez ceci

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildButton(context, 'MES ACTIONS', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MesActionPage(userId: userId, selectedIndex: 1, onItemTapped: (int index) {}, firstName: '', lastName: '',), // Utilisez userId ici
              ),
            );
          }),
          SizedBox(height: 10),
          _buildButton(context, 'MES PROJETS', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MesProjetsPage(userId: userId), // Utilisez userId ici
              ),
            );
          }),
          SizedBox(height: 10),
          _buildButton(context, 'TRADITIONS PARTAGÉS', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MesTraditionsPage(userId: userId,selectedIndex: 3, onItemTapped: (int index) {},), // Utilisez userId ici
              ),
            );
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
