import 'package:cito_act_mobile_app/views/stream_section.dart';
import 'package:flutter/material.dart';
import 'package:cito_act_mobile_app/utils/bottom_nav_bar.dart';

class AcceuilPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  AcceuilPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamSection(title: 'ACTION', collection: 'actions', userId: 'userId', firstName: 'firstName', lastName: 'lastName',),
            StreamSection(title: 'PROJET', collection: 'projets', userId: '', firstName: '', lastName: '',),
            StreamSection(title: 'TRADITION', collection: 'traditions', userId: '', firstName: '', lastName: '',),
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
