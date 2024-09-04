import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:seaaegis/providers/beach_data_provider.dart';
import 'package:seaaegis/views/beach_data/widgets/calender.dart';
import 'package:seaaegis/views/beach_data/widgets/hourly_data.dart';
import 'package:seaaegis/views/beach_data/widgets/weather_info.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';

import 'widgets/alert_box.dart';

class BeachStats extends StatelessWidget {
  const BeachStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BeachDataProvider>(builder: (context, provider, _) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF81D4FA),
                      Color(0xFF3DA0F1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(2, 3))
                  ],
                ),
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
                    CalendarWidget(
                      provider: provider,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              HourlyForecast(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                    .copyWith(top: 0),
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.symmetric(horizontal: 16),
                  // height: 600,
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
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            height: 150,
                            width: 140,
                            image: AssetImage('assets/weather/small_rain.png'),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Rain Showers',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '25°',
                                style: TextStyle(
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
              const AlertBox(isSafeToGo: false, bestTimeToGo: '9:40'),
              const WeatherInfoGrid(
                  windSpeed: 9,
                  windDirection: 'North-East',
                  waveHeight: 3.4,
                  visibility: 5.4,
                  precipitation: 3.4,
                  humidity: 3.2)
            ],
          ),
        ),
      );
    });
  }
}
