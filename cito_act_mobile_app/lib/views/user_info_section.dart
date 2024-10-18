import 'package:cito_act_mobile_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final UserModel user;

  UserInfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Infos Utilisateurs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildInfoRow('ID', user.uid),
          _buildInfoRow('Nom', user.lastName),
          _buildInfoRow('Prénom', user.firstName),
          _buildInfoRow('Email', user.email),
          _buildInfoRow('Tél', user.phone),
          _buildInfoRow('Role', user.role),
          _buildInfoRow('Point De Participation', '2000'), // Exemple fixe
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label : ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
