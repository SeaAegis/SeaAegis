import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';

import 'package:seaaegis/views/beach_data/widgets/alert_box.dart';
import 'package:seaaegis/views/beach_data/widgets/hourly_data.dart';
import 'package:seaaegis/views/beach_data/widgets/weather_info.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';

class BeachStats extends StatefulWidget {
  final BeachConditions beachConditions;
  final List<BeachConditions> conditionList;
  const BeachStats(
      {super.key, required this.beachConditions, required this.conditionList});

  @override
  State<BeachStats> createState() => _BeachStatsState();
}

class _BeachStatsState extends State<BeachStats> {
  @override
  Widget build(BuildContext context) {
    final condition = widget.beachConditions;
    final conditionList = widget.conditionList;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your existing UI code
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
            HourlyForecast(
              conditionList: conditionList,
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
                          offset: const Offset(2, 3))
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          height: 150,
                          width: 140,
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
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${condition.airTempC}°C',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            AlertBox(
              beachConditions: condition,
            ),
            WeatherInfoGrid(
              windSpeed: condition.windSpeedMps,
              windDirection: 'North-East', // Example direction
              waveHeight: condition.waveHeightM,
              visibility: condition.visibilityKm,
              precipitation: condition.precipitation,
              humidity: condition.humidity,
            ),
          ],
        ),
      ),
    );
  }
}
