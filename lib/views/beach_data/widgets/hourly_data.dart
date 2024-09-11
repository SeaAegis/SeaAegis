import 'package:flutter/material.dart';

import 'package:seaaegis/testApi/tester1.dart';

class HourlyForecast extends StatefulWidget {
  final List<BeachConditions> conditionList;
  final Function(int) onHourSelected;

  const HourlyForecast({
    super.key,
    required this.conditionList,
    required this.onHourSelected,
  });

  @override
  State<HourlyForecast> createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: widget.conditionList.length,
          itemBuilder: (context, index) {
            final item = widget.conditionList[index];
            final bool isSelected = index == selectedIndex;

            final bool isNewDay = index == 0 ||
                (item.time.day != widget.conditionList[index - 1].time.day);

            return GestureDetector(
              // Add onTap for hour selection
              onTap: () {
                setState(() {
                  widget.onHourSelected(index);
                  selectedIndex = index;
                });
                // Notify parent about the selected hour
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    // if (isNewDay) // Add a header if the day changes
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "${item.time.day}/${item.time.month}/${item.time.year}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
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
                          Text(
                            "${item.time.hour}:${item.time.minute}", // Displaying hour in HH:00 format
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Display temperature from the conditionList
                          Text(
                            "${item.airTempC}°", // Temperature in Celsius
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool isNowInRangeWithTolerance(DateTime targetTime, int minutesTolerance) {
    DateTime now = DateTime.now();
    // print(targetTime);
    // Define the start and end times with the given tolerance
    DateTime startTime =
        targetTime.subtract(Duration(minutes: minutesTolerance));
    DateTime endTime = targetTime.add(Duration(minutes: minutesTolerance));
    // print(startTime);
    // print(endTime);
    // Check if the current time is within the tolerance range
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
}
