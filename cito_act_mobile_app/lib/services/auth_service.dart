import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart'; // Assurez-vous que le chemin d'importation est correct

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convertir l'utilisateur Firebase en UserModel
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid, firstName: '', lastName: '', email: user.email!, phone: '') : null;
  }

  // Inscription avec email et mot de passe
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print("Error during sign-up: $e");
      return null;
    }
  }

  // Connexion avec email et mot de passe
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print("Error during sign-in: $error");
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Vérifie si l'utilisateur est connecté
  bool get isAuthenticated {
    return _auth.currentUser != null;
  }
}
