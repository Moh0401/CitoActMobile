import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'tradition_detail_page.dart';
import '../models/tradition.dart';

class TraditionPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  TraditionPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Traditions', style: TextStyle(color: Colors.black)),
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
                    Tradition(
                      title: 'Lorem Ipsum Dolor',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna.',
                      imagePath: 'assets/images/tradition1.jpg',
                    ),
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    Tradition(
                      title: 'Dolor Sit Amet',
                      description:
                          'Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus.',
                      imagePath: 'assets/images/tradition2.jpg',
                    ),
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    Tradition(
                      title: 'Consectetur Adipiscing',
                      description:
                          'Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
                      imagePath: 'assets/images/tradition3.jpg',
                    ),
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

  Widget buildCard(BuildContext context, Tradition tradition) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.asset(tradition.imagePath, fit: BoxFit.cover, width: 80),
        title: Text(tradition.title,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tradition.description),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TraditionDetailPage(
                  tradition: tradition,
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
