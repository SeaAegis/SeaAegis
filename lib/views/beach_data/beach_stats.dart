import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';
import 'package:seaaegis/views/beach_data/widgets/alert_box.dart';
import 'package:seaaegis/views/beach_data/widgets/hourly_data.dart';
import 'package:seaaegis/views/beach_data/widgets/weather_info.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';

class BeachStats extends StatefulWidget {
  final BeachConditions beachConditions;
  final List<BeachConditions> conditionList;

  const BeachStats({
    super.key,
    required this.beachConditions,
    required this.conditionList,
  });

  @override
  State<BeachStats> createState() => _BeachStatsState();
}

class _BeachStatsState extends State<BeachStats> {
  int selectedHourIndex = 0; // Initialize to the nearest hour (or first hour)
  BeachConditions? nextSafeCondition;

  @override
  void initState() {
    super.initState();
    // Find the first next safe condition when the widget is initialized
    nextSafeCondition =
        findNextSafeHour(widget.conditionList, selectedHourIndex);
  }

  String getDirectionFromDegrees(double degrees) {
    // Normalize the degrees to a range of 0-360
    degrees = degrees % 360;

    // Define direction ranges in degrees
    final Map<String, List<double>> directions = {
      'North': [337.5, 360.0],
      'North-East': [22.5, 67.5],
      'East': [67.5, 112.5],
      'South-East': [112.5, 157.5],
      'South': [157.5, 202.5],
      'South-West': [202.5, 247.5],
      'West': [247.5, 292.5],
      'North-West': [292.5, 337.5],
    };

    // Find the direction corresponding to the degrees
    for (var entry in directions.entries) {
      if ((degrees >= entry.value[0] && degrees < entry.value[1]) ||
          (entry.value[0] > entry.value[1] &&
              (degrees >= entry.value[0] || degrees < entry.value[1]))) {
        return entry.key;
      }
    }

    // Default case, though it should never reach here
    return 'Unknown';
  }

  BeachConditions? findNextSafeHour(
      List<BeachConditions> conditionsList, int startIndex) {
    for (var i = startIndex + 1; i < conditionsList.length; i++) {
      if (conditionsList[i].isSafeToVisit()) {
        return conditionsList[i]; // Return the first safe condition found
      }
    }
    return null; // Return null if no safe condition is found
  }

  void updateSelectedHour(int index) {
    setState(() {
      selectedHourIndex = index; // Update the selected hour index
      nextSafeCondition = findNextSafeHour(widget.conditionList,
          selectedHourIndex); // Find next safe hour from the new index
    });
  }

  @override
  Widget build(BuildContext context) {
    final condition =
        widget.conditionList[selectedHourIndex]; // Get the selected hour's data
    final conditionList = widget.conditionList;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BasicAppBar(
              title: Text(
                'Beach Name',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            const SizedBox(height: 12),
            // Pass a callback function to update the selected hour
            HourlyForecast(
              conditionList: conditionList,
              onHourSelected: (int index) {
                updateSelectedHour(
                    index); // Update state when a new hour is selected
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  .copyWith(top: 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3DA0F1),
                      Color(0xFF81D4FA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          height: 150,
                          width: 120,
                          image: AssetImage('assets/weather/small_rain.png'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              condition.isSafeToVisit()
                                  ? 'Safe to Visit'
                                  : 'Unsafe Conditions',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${condition.airTempC}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AlertBox(
              beachConditions: condition,
              nextSafe: nextSafeCondition, // Pass the next safe condition
            ),
            WeatherInfoGrid(
              windSpeed: condition.windSpeedMps,
              windDirection: getDirectionFromDegrees(
                  condition.currentDirection), // Example direction
              waveHeight: condition.waveHeightM,
              visibility: condition.visibilityKm,
              precipitation: condition.precipitation,
              humidity: condition.humidity,
              time: condition.time,
              conditionList: conditionList,
            ),
          ],
        ),
      ),
    );
  }
}
