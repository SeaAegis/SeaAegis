import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyData = [
    {"time": "12:00", "temp": "26", "icon": Icons.wb_sunny},
    {"time": "02:00", "temp": "28", "icon": Icons.cloud},
    {"time": "04:00", "temp": "23", "icon": Icons.thunderstorm},
    {"time": "06:00", "temp": "26", "icon": Icons.wb_sunny},
    {"time": "08:00", "temp": "28", "icon": Icons.cloud},
  ];

  HourlyForecast({super.key});

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
          itemCount: hourlyData.length,
          itemBuilder: (context, index) {
            final item = hourlyData[index];
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
                          : null, // Dark gray for unselected items
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(2, 3))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['time'],
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          item['icon'],
                          color:
                              isSelected ? Colors.white : Colors.grey.shade300,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${item['temp']}°",
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
