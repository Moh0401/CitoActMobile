import 'package:cito_act_mobile_app/views/notification_page.dart';
import 'package:cito_act_mobile_app/views/stream_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cito_act_mobile_app/utils/bottom_nav_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AcceuilPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  AcceuilPage({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    
    // Initialiser le plugin des notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Créer le canal de notification
    _createNotificationChannel();

    // Écouter les messages reçus
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Gérer les messages reçus pendant que l'application est au premier plan
      print('Message received: ${message.notification?.title}');
      
      // Afficher une notification locale
      _showNotification(message);
    });
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // Remplacez par l'ID de votre canal
      'your_channel_name', // Remplacez par le nom de votre canal
      description: 'your_channel_description', // Remplacez par la description de votre canal
      importance: Importance.high,
    );

    // Créer le canal
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

    Future<void> _showNotification(RemoteMessage message) async {
      // Afficher la notification locale
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: 'item x',
      );

      // Sauvegarder la notification dans Firestore
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': userId,
          'title': message.notification?.title,
          'body': message.notification?.body,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
          'data': message.data,
        });
      }
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        centerTitle: true,
               actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Naviguer vers la page des notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
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
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }
}
