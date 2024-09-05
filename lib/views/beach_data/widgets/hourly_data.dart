import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart'; // Assuming BeachConditions is imported from tester1.dart

class HourlyForecast extends StatelessWidget {
  final List<BeachConditions> conditionList;

  const HourlyForecast({super.key, required this.conditionList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: conditionList.length,
          itemBuilder: (context, index) {
            final item = conditionList[index];
            final bool isSelected = index == 1;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      color: !isSelected ? const Color(0xFF81D4FA) : null,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF29B6F6), // Light Sky Blue
                                Color(0xFFD656EC), // Purple Tint
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(25),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display time from the conditionList
                        Text(
                          "${item.time.hour}:00", // Displaying hour in HH:00 format
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Display temperature from the conditionList
                        Text(
                          "${item.airTempC}°", // Temperature in Celsius
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
