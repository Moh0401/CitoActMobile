class UserModel {
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  String role; // Nouveau champ
  String? imageUrl; // Ajoutez ce champ pour stocker l'URL de l'image

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.role = 'citoyen', // Valeur par défaut
    this.imageUrl, // Ajoutez ce paramètre
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
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'] ?? 'citoyen',
      imageUrl: map['imageUrl'], // Récupérer l'URL de l'image
    );
  }
}
