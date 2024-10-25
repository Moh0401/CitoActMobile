import 'package:cito_act_mobile_app/views/projet_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cito_act_mobile_app/services/auth_service.dart';
import 'views/first_page.dart';
import 'views/login_page.dart';
import 'views/sign_up_page.dart';
import 'views/after_login_page.dart';
import 'views/mes_actions_page.dart';
import 'views/mes_projets_page.dart';
import 'views/mes_traditions_page.dart';
import 'views/acceuil_page.dart';
import 'views/action_page.dart';
import 'views/projet_page.dart';
import 'views/tradition_page.dart';
import 'views/profile_page.dart';
import 'views/error_page.dart'; // Ajoutez cette ligne

final AuthService _authService = AuthService();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/first':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/after-login':
        return MaterialPageRoute(builder: (_) => AfterLoginPage());

    // Routes sécurisées
      case '/mes-actions':
      case '/mes-projets':
      case '/traditions-partages':
      case '/home':
      case '/action':
      case '/projet':
      case '/tradition':
      case '/profil':
        if (_authService.isAuthenticated) {
          // Redirige vers la page appropriée
          switch (settings.name) {
            case '/mes-actions':
              if (args is String) {
                return MaterialPageRoute(builder: (_) => MesActionPage(userId: args,selectedIndex: 1, onItemTapped: (int index) {},  firstName: '', lastName: '',));
              } else {
                return MaterialPageRoute(builder: (_) => ErrorPage(message: "ID utilisateur manquant"));
              }
            case '/mes-projets':
              if (args is String) {
                return MaterialPageRoute(builder: (_) => ProjetDetailPage(
          projetId: '',  // Remplir ces paramètres plus tard avec les arguments
          groupName: '',
          selectedIndex: 2,
          onItemTapped: (index) {},
          ));
              } else {
                return MaterialPageRoute(builder: (_) => ErrorPage(message: "ID utilisateur manquant"));
              }
              case '/traditions-partages':
            if (args is String) {
              return MaterialPageRoute(builder: (_) => MesTraditionsPage(userId: args,
                selectedIndex: 3, // par exemple
                onItemTapped: (index) {
                  // gérer les actions de la barre de navigation en bas si nécessaire
                },));
            } else {
              return MaterialPageRoute(builder: (_) => ErrorPage(message: "ID utilisateur manquant"));
            }            case '/home':
              return MaterialPageRoute(builder: (_) => AcceuilPage(selectedIndex: 0, onItemTapped: (int index) {}));
            case '/action':
              return MaterialPageRoute(builder: (_) => ActionPage(selectedIndex: 1, onItemTapped: (int index) {}, userId: '', firstName: '', lastName: '',));
            case '/projet':
              return MaterialPageRoute(builder: (_) => ProjetPage(selectedIndex: 2, onItemTapped: (int index) {}));
            case '/tradition':
              return MaterialPageRoute(builder: (_) => TraditionPage(selectedIndex: 3, onItemTapped: (int index) {}));
            case '/profil':
              return MaterialPageRoute(builder: (_) => ProfilPage(selectedIndex: 4, onItemTapped: (int index) {}));
            default:
              return MaterialPageRoute(builder: (_) => FirstPage());
          }
        } else {
          // Redirection vers la page de connexion si l'utilisateur n'est pas authentifié
          return MaterialPageRoute(builder: (_) => LoginPage());
        }

      default:
        return MaterialPageRoute(builder: (_) => FirstPage());
    }
  }
}