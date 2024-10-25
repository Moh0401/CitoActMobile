import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Erreur')),
      body: Center(child: Text(message)),
    );
  }
}