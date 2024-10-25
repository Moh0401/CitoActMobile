class ActionModel {
  String actionId;
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
  int likeCount; // Ajout du champ likeCount
  String? chatGroupId; // Nouveau champ pour le groupe de chat


  ActionModel({
    required this.actionId,
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
    this.likeCount = 0, // Initialisé à 0 par défaut
    this.chatGroupId, // Optionnel, initialisé à null

  });

  // Méthode pour convertir en Map
  Map<String, dynamic> toMap() {
    return {
      'actionId': actionId,
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
      'likeCount': likeCount, // Ajout de likeCount
      'chatGroupId': chatGroupId, // Ajouter chatGroupId au map

    };
  }

  // Méthode pour créer un objet ActionModel à partir d'un Map
  factory ActionModel.fromMap(Map<String, dynamic> map) {
    return ActionModel(
      actionId: map['actionId'],
      titre: map['titre'],
      description: map['description'],
      localisation: map['localisation'],
      debut: map['debut'],
      fin: map['fin'],
      besoin: map['besoin'],
      telephone: map['telephone'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profilePic: map['profilePic'],
      valider: map['valider'] ?? false,
      likeCount: map['likeCount'] ?? 0, // Ajout de likeCount
      chatGroupId: map['chatGroupId'], // Récupérer chatGroupId
    );
  }
}
