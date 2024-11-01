import 'package:cito_act_mobile_app/models/ong_model.dart';
import 'package:cito_act_mobile_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final dynamic user;

  const UserInfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    bool isOng = user is UserOngModel;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Infos Utilisateurs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          if (isOng) ...[
            _buildInfoRow('Nom de l\'organisation', (user as UserOngModel).name)
          ] else ...[
            _buildInfoRow('Nom', (user as UserModel).lastName),
            _buildInfoRow('Prénom', user.firstName),
          ],
          _buildInfoRow('Email', user.email),
          _buildInfoRow('Tél', user.phone),
          _buildInfoRow('Role', isOng ? 'ONG' : 'Citoyen'),
          if (!isOng)
            _buildInfoRow('Points De Participation', '2000'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
