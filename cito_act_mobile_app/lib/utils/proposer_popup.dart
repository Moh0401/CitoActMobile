import 'package:flutter/material.dart';
import '../utils/proposer_action_popup.dart';  // Importez les popups spécifiques
import '../utils/proposer_projet_popup.dart';
import '../utils/proposer_tradition_popup.dart';

class ProposerPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF6887B0), // Fond bleu
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ouverture du pop-up pour "Proposer Une Action"
            _buildPopupButton(context, 'Proposer Une Action', () {
              Navigator.of(context).pop(); // Ferme le pop-up principal
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProposerActionPopup(); // Affiche le pop-up spécifique
                },
              );
            }),

            SizedBox(height: 10),

            // Ouverture du pop-up pour "Proposer Un Projet"
            _buildPopupButton(context, 'Proposer Un Projet', () {
              Navigator.of(context).pop(); // Ferme le pop-up principal
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProposerProjetPopup(); // Affiche le pop-up spécifique
                },
              );
            }),

            SizedBox(height: 10),

            // Ouverture du pop-up pour "Publier Une Tradition"
            _buildPopupButton(context, 'Publier Une Tradition', () {
              Navigator.of(context).pop(); // Ferme le pop-up principal
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProposerTraditionPopup(); // Affiche le pop-up spécifique
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Color(0xFFFFFFFF), // Fond blanc des boutons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF6887B0)), // Texte bleu
      ),
    );
  }
}
