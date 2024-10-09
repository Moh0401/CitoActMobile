import 'package:flutter/material.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/search_bar.dart';
import 'action_detail_page.dart';
import '../models/action.dart';

class ActionPage extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ActionPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Actions', style: TextStyle(color: Colors.black)),
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
                    ActionItem(
                      title: 'Lorem Ipsum',
                      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi.',
                      imagePath: 'assets/images/action1.jfif',
                    ),
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    ActionItem(
                      title: 'Dolor Sit Amet',
                      description: 'Consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna.',
                      imagePath: 'assets/images/action2.jpg',
                    ),
                  ),
                  SizedBox(height: 16),
                  buildCard(
                    context,
                    ActionItem(
                      title: 'Consectetur Adipiscing',
                      description: 'Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla.',
                      imagePath: 'assets/images/action3.jpg',
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

  Widget buildCard(BuildContext context, ActionItem action) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF6887B0), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.asset(action.imagePath, fit: BoxFit.cover, width: 80),
        title: Text(action.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(action.description),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionDetailPage(
                  action: action,
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