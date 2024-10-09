import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _navItems = [
      {'icon': Icons.home, 'label': 'Accueil', 'route': '/home'},
      {'icon': Icons.mood, 'label': 'Action', 'route': '/action'},
      {'icon': Icons.wb_sunny, 'label': 'Projet', 'route': '/projet'},
      {'icon': Icons.brightness_5, 'label': 'Tradition', 'route': '/tradition'},
      {'icon': Icons.person_outline, 'label': 'Profil', 'route': '/profil'}, // Ajoutez le chemin pour Profil si nécessaire
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7995BC),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_navItems.length, (index) {
            return GestureDetector(
              onTap: () {
                // Navigation vers la route correspondante
                Navigator.pushNamed(context, _navItems[index]['route']);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _navItems[index]['icon'],
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                  Text(
                    _navItems[index]['label'],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
