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

final AuthService _authService = AuthService();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
          return MaterialPageRoute(builder: (_) {
            switch (settings.name) {
              case '/mes-actions':
                return MesActionPage();
              case '/mes-projets':
                return MesProjetsPage();
              case '/traditions-partages':
                return MesTraditionsPage();
              case '/home':
                return AcceuilPage(selectedIndex: 0, onItemTapped: (int index) {});
              case '/action':
                return ActionPage(selectedIndex: 1, onItemTapped: (int index) {});
              case '/projet':
                return ProjetPage(selectedIndex: 2, onItemTapped: (int index) {});
              case '/tradition':
                return TraditionPage(selectedIndex: 3, onItemTapped: (int index) {});
              case '/profil':
                return ProfilPage(selectedIndex: 4, onItemTapped: (int index) {});
              default:
                return FirstPage();
            }
          });
        } else {
          // Redirection vers la page de connexion si l'utilisateur n'est pas authentifié
          return MaterialPageRoute(builder: (_) => LoginPage());
        }

      default:
        return MaterialPageRoute(builder: (_) => FirstPage());
    }
  }
}
