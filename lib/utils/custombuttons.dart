import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final String textvalue;
  final Function nav;
  CustomButtons({super.key, required this.textvalue, required this.nav});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        nav();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blue[400]),
      ),
      child: Text(
        textvalue,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
