import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final bool isSafeToGo;
  final String bestTimeToGo;
  const AlertBox(
      {super.key, required this.isSafeToGo, required this.bestTimeToGo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF81D4FA),
                Color(0xFF55ACF3),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(2, 3))
            ]),
        child: Column(
          children: [
            Text(
              isSafeToGo
                  ? 'It is safe to go to the beach'
                  : 'Not safe to go to the beach',
              style: TextStyle(
                color: isSafeToGo ? Colors.green : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Best time to go: $bestTimeToGo',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
