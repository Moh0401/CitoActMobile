import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cito_act_mobile_app/utils/proposer_action_popup.dart';
import 'package:cito_act_mobile_app/utils/proposer_projet_popup.dart';
import 'package:cito_act_mobile_app/utils/proposer_tradition_popup.dart';

class AfterLoginPage extends StatefulWidget {
  const AfterLoginPage({super.key});

  @override
  _AfterLoginPageState createState() => _AfterLoginPageState();
}

class _AfterLoginPageState extends State<AfterLoginPage> {
  String? firstName; // Variable pour stocker le prénom de l'utilisateur
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
        print('User Document: ${userDoc.data()}'); // Vérifie les données récupérées
        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'];
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espacement en haut
          const SizedBox(height: 80),

          // Contenu avec padding horizontal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour',
                  style: GoogleFonts.b612Mono(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  firstName ??
                      'Utilisateur', // Afficher le prénom ou "Utilisateur" par défaut
                  style: GoogleFonts.balooChettan2(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Qu'allez vous faire aujourd'hui ?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // Boutons pour Proposer une action, Proposer un projet, Publier une tradition
                CustomButton(
                  text: 'Proposer une action',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ProposerActionPopup();
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'Proposer un projet',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ProposerProjetPopup();
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'Publier une tradition',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ProposerTraditionPopup();
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bouton Accueil pleine largeur sans padding horizontal
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6887B0),
                minimumSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Accueil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 65,
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          side: const BorderSide(color: Color(0xFF5C7EAA)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF5C7EAA),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
