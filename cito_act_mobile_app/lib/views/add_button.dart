import 'package:cito_act_mobile_app/utils/proposer_popup.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProposerPopup();
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color(0xFF6887B0),
        ),
      ),
    );
  }
}
