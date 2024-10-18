class ProjetModel {
  String projetId;
  String titre;
  String description;
  String localisation;
  String debut;
  String fin;
  String besoin;
  String telephone;
  String imageUrl;
  String userId;
  String firstName;
  String lastName;
  String profilePic;
  bool valider;
  int likes; // Nouveau champ pour les likes

  ProjetModel({
    required this.projetId,
    required this.titre,
    required this.description,
    required this.localisation,
    required this.debut,
    required this.fin,
    required this.besoin,
    required this.telephone,
    required this.imageUrl,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    this.valider = false,
    this.likes = 0, // Initialisation par défaut à 0 like
  });

  // Convertir ProjetModel en map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'projetId': projetId,
      'titre': titre,
      'description': description,
      'localisation': localisation,
      'debut': debut,
      'fin': fin,
      'besoin': besoin,
      'telephone': telephone,
      'imageUrl': imageUrl,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'profilePic': profilePic,
      'valider': valider,
      'likes': likes, // Ajout du champ likes
    };
  }

  // Créer un ProjetModel à partir d'un document Firestore
  factory ProjetModel.fromMap(Map<String, dynamic> map) {
    return ProjetModel(
      projetId: map['projetId'],
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      localisation: map['localisation'] ?? '',
      debut: map['debut'] ?? '',
      fin: map['fin'] ?? '',
      besoin: map['besoin'] ?? '',
      telephone: map['telephone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      profilePic: map['profilePic'] ?? '',
      valider: map['valider'] ?? false,
      likes: map['likes'] ?? 0, // Par défaut à 0 like
    );
  }
}
