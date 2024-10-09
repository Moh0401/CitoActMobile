import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'projet_detail_page.dart';
import '../models/projet.dart';

class ProjetPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ProjetPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    String groupName = 'Nom du Groupe'; // Définissez ici le nom du groupe

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Projets', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomSearchBar(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildCard(
                    context,
                    Projet(
                      title: 'Projet 1',
                      description: 'Description du projet 1. Ce projet vise à améliorer ...',
                      imagePath: 'assets/images/projet1.jpg',
                    ),
                    groupName, // Ajoutez groupName ici
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    Projet(
                      title: 'Projet 2',
                      description: 'Description du projet 2. Ce projet se concentre sur ...',
                      imagePath: 'assets/images/projet2.jpg',
                    ),
                    groupName, // Ajoutez groupName ici
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    Projet(
                      title: 'Projet 3',
                      description: 'Description du projet 3. Ce projet a pour but de ...',
                      imagePath: 'assets/images/projet3.jpg',
                    ),
                    groupName, // Ajoutez groupName ici
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }

  Widget buildCard(BuildContext context, Projet projet, String groupName) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.asset(projet.imagePath, fit: BoxFit.cover, width: 80),
        title: Text(projet.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(projet.description),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjetDetailPage(
                  projet: projet,
                  groupName: groupName, // Passez groupName ici
                  selectedIndex: selectedIndex,
                  onItemTapped: onItemTapped,
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            side: BorderSide(color: Color(0xFF6887B0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text('Voir', style: TextStyle(color: Color(0xFF6887B0))),
        ),
      ),
    );
  }
}
