import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';
import 'package:intl/intl.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gérez ici le message reçu en arrière-plan
  print("Handling a background message: ${message.messageId}");
}
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // Intl.defaultLocale = 'fr_FR';
  // Initialiser les notifications locales
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitoAct',
      // Définir la locale pour l'application
      //locale: const Locale('fr', 'FR'),
      /*supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],*/
      theme: ThemeData(
        textTheme: GoogleFonts.balooChettan2TextTheme(),
        primaryColor: Colors.white, // Couleur primaire blanche
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white, // Couleur de fond blanche
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white, // Couleur par défaut des boutons
          textTheme:
              ButtonTextTheme.primary, // Texte en couleur primaire (blanc)
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.white, // Fond de la barre d'applications blanc
          iconTheme: IconThemeData(color: Colors.black), // Icônes en noir
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20), // Texte de la barre d'applications
        ),
      ),
      initialRoute: '/first', // Route initiale
      onGenerateRoute: RouteGenerator.generateRoute,    );
  }
}
