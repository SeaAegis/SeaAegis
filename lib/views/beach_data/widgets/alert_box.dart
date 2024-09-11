import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';

class AlertBox extends StatefulWidget {
  final BeachConditions beachConditions;
  final BeachConditions? nextSafe;

  const AlertBox({
    super.key,
    required this.beachConditions,
    required this.nextSafe,
  });

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  String formatTimeToIST(DateTime dateTime) {
    // Convert UTC time to IST
    final istTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));

    // Format the time to Indian Standard Time (IST) format (HH:mm, dd/MM/yyyy)
    return "${istTime.hour.toString().padLeft(2, '0')}:${istTime.minute.toString().padLeft(2, '0')}, ${istTime.day.toString().padLeft(2, '0')}/${istTime.month.toString().padLeft(2, '0')}/${istTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    final condition = widget.beachConditions;
    final nextSafe = widget.nextSafe;
    bool isSafeToGo = condition.isSafeToVisit();
    String bestTimeToGo = isSafeToGo
        ? formatTimeToIST(condition.time)
        : nextSafe != null
            ? formatTimeToIST(nextSafe.time)
            : "N/A";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
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
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              isSafeToGo
                  ? 'It is safe to go to the beach'
                  : 'Unsafe conditions: ${condition.getSafetyIssues()}',
              style: TextStyle(
                color: isSafeToGo ? Colors.white : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              !isSafeToGo
                  ? 'Best time to go: $bestTimeToGo'
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
