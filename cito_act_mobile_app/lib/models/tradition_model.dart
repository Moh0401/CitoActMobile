// TraditionModel class with user fields
class TraditionModel {
  String traditionId;
  String titre;
  String description;
  String praticiens;
  String menaces;
  String origine;
  String? imageUrl;
  String? videoUrl;
  String? documentUrl;
  String? audioUrl;
  bool valider;

  // New fields for user data
  String userId;        // User ID
  String firstName;     // First name
  String lastName;      // Last name
  String? profilePic;   // Profile picture URL (optional)
  int likes; // Nouveau champ


  TraditionModel({
    required this.traditionId,
    required this.titre,
    required this.description,
    required this.praticiens,
    required this.menaces,
    required this.origine,
    this.imageUrl,
    this.videoUrl,
    this.documentUrl,
    this.audioUrl,
    this.valider = false,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profilePic,
    this.likes = 0, // Initialisation par défaut
  });

  // Convert TraditionModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'traditionId': traditionId,
      'titre': titre, // Ici aussi, utilisez 'titre'
      'description': description,
      'praticiens': praticiens,
      'menaces': menaces,
      'origine': origine,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'documentUrl': documentUrl,
      'audioUrl': audioUrl,
      'valider': valider,
      'userId': userId,           // Added userId
      'firstName': firstName,     // Added firstName
      'lastName': lastName,       // Added lastName
      'profilePic': profilePic,   // Added profilePic (optional)
      'likes': likes,
    };

  }

  // Create a TraditionModel instance from Firestore map
  factory TraditionModel.fromMap(Map<String, dynamic> map) {
    return TraditionModel(
      traditionId: map['traditionId'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      praticiens: map['praticiens'] ?? '',
      menaces: map['menaces'] ?? '',
      origine: map['origine'] ?? '',
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      documentUrl: map['documentUrl'],
      audioUrl: map['audioUrl'],
      valider: map['valider'] ?? false,
      userId: map['userId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      profilePic: map['profilePic'],
      likes: map['likes'] ?? 0, // Gestion du champ likes

    );
  }


}
