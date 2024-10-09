import 'package:flutter/material.dart';
import '../models/tradition.dart';
import '../utils/bottom_nav_bar.dart';

class TraditionDetailPage extends StatelessWidget {
  final Tradition tradition;
  final int selectedIndex;
  final Function(int) onItemTapped;

  TraditionDetailPage({
    required this.tradition,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                tradition.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tradition.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6887B0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    tradition.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}