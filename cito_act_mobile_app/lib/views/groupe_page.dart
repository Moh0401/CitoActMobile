// /lib/views/group_page.dart
import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  final String groupName;

  GroupPage({Key? key, required this.groupName}) : super(key: key);

  final List<String> groupMembers = [
    'Oumar Kanté',
    'Alpha Traoré',
    'Fatou Sow',
    'Moussa Diallo',
  ];

  final List<String> groupPatrons = [
    'Patron 1',
    'Patron 2',
    'Patron 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF6887B0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(groupName, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.group, color: Color(0xFF6887B0)),
            onPressed: () {
              _showGroupMembersDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.star, color: Color(0xFF6887B0)),
            onPressed: () {
              _showPatronsDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildGroupPost('Oumar Kanté', 'LOREM IPSUM DOLOR SIT AMET...'),
          SizedBox(height: 16),
          _buildGroupPost('Alpha Traoré', 'LOREM IPSUM DOLOR SIT AMET...', hasAttachment: true),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Color(0xFF6887B0)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tapez un message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF6887B0)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGroupMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Membres du groupe'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: groupMembers.map((member) {
                return ListTile(
                  title: Text(member),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fermer', style: TextStyle(color: Color(0xFF6887B0))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPatronsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Parrains de l\'action'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: groupPatrons.map((patron) {
                return ListTile(
                  title: Text(patron),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fermer', style: TextStyle(color: Color(0xFF6887B0))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupPost(String name, String content, {bool hasAttachment = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF6887B0),
                  radius: 20,
                  child: Text(name[0], style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 12),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            Text(content, style: TextStyle(fontSize: 14)),
            if (hasAttachment)
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file, size: 20, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('fichier.pdf', style: TextStyle(color: Colors.grey[600])),
                    Spacer(),
                    Icon(Icons.download, size: 20, color: Colors.grey[600]),
                  ],
                ),
              ),
            SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.thumb_up_outlined, size: 18, color: Color(0xFF6887B0)),
                  label: Text('LIKE', style: TextStyle(color: Color(0xFF6887B0), fontSize: 14)),
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                Spacer(),
                TextButton.icon(
                  icon: Icon(Icons.comment_outlined, size: 18, color: Color(0xFF6887B0)),
                  label: Text('COMMENTAIRE', style: TextStyle(color: Color(0xFF6887B0), fontSize: 14)),
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
