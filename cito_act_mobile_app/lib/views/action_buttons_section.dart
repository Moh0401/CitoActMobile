import 'package:flutter/material.dart';

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
            Navigator.pushNamed(context, '/mes-actions');
          }),
          SizedBox(height: 10),
          _buildButton(context, 'MES PROJETS', () {
            Navigator.pushNamed(context, '/mes-projets');
          }),
          SizedBox(height: 10),
          _buildButton(context, 'TRADITIONS PARTAGÉS', () {
            Navigator.pushNamed(context, '/traditions-partages');
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
