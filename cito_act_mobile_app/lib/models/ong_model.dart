class UserOngModel {
  String uid;
  String name;
  String email;
  String phone;
  String role; // Nouveau champ
  String? imageUrl; // Ajoutez ce champ pour stocker l'URL de l'image
  String? fcmToken; // Ajoutez cette ligne
  String countryCode; // Ajoutez cette ligne



  UserOngModel({
    required this.uid,

    required this.name,
    required this.email,
    required this.phone,
    required this.role, // Valeur par défaut
    this.imageUrl, // Ajoutez ce paramètre
    this.fcmToken, // Ajoutez cette ligne
    required this.countryCode, // Valeur par défaut


  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'imageUrl': imageUrl, // N'oubliez pas d'inclure l'URL de l'image
      'fcmToken': fcmToken,
      'countryCode': countryCode,
    };
  }

  factory UserOngModel.fromMap(Map<String, dynamic> map) {
    return UserOngModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'] ,
      imageUrl: map['imageUrl'], // Récupérer l'URL de l'image
      fcmToken: map['fcmToken'],
      countryCode: map['countryCode'],
    );
  }
}
