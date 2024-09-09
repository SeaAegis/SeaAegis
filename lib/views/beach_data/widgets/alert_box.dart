import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';

class AlertBox extends StatefulWidget {
  // final bool isSafeToGo;
  // final String bestTimeToGo;
  final BeachConditions beachConditions;
  const AlertBox({super.key, required this.beachConditions});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    final condition = widget.beachConditions;
    bool isSafeToGo = condition.isSafeToVisit();
    String bestTimeToGo = formatTimeToIST(condition.time);
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
                  : condition.getSafetyIssues(),
              style: TextStyle(
                color: isSafeToGo ? Colors.green : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              !isSafeToGo
                  ? 'Best time to go: ${bestTimeToGo.substring(0, 16)}'
                  : "You can visit now",
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
