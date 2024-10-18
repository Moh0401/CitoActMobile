import 'package:cito_act_mobile_app/views/acceuil_page.dart';
import 'package:flutter/material.dart';
import '../views/action_page.dart';
import '../views/projet_page.dart';
import '../views/tradition_page.dart';
import '../views/profile_page.dart';
import 'bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _getPages() {
    return [
      AcceuilPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      ActionPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        userId: '',
        firstName: '',
        lastName: '',
      ),
      ProjetPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      TraditionPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      ProfilPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPages()[_selectedIndex], // Utilisation de l'index sélectionné pour afficher la page
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
