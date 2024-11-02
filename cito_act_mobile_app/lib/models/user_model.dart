class UserModel  {
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  String role; // Nouveau champ
  String? imageUrl; // Ajoutez ce champ pour stocker l'URL de l'image
  String? fcmToken; // Ajoutez cette ligne


  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role , // Valeur par défaut
    this.imageUrl, // Ajoutez ce paramètre
    this.fcmToken, // Ajoutez cette ligne


  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'imageUrl': imageUrl, // N'oubliez pas d'inclure l'URL de l'image
      'fcmToken': fcmToken, // Ajoutez cette lig
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'] ,
      imageUrl: map['imageUrl'], // Récupérer l'URL de l'image
      fcmToken: map['fcmToken'], // Récupérer l'URL de l'image
    );
  }
}
