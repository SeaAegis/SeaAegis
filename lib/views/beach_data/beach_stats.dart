import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:seaaegis/helpers/dark_mode.dart';
import 'package:seaaegis/providers/beach_data_provider.dart';
import 'package:seaaegis/views/beach_data/widgets/calender.dart';
import 'package:seaaegis/views/beach_data/widgets/hourly_data.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';

class BeachStats extends StatelessWidget {
  const BeachStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BeachDataProvider>(builder: (context, provider, _) {
      return Scaffold(
        // appBar: const BasicAppBar(
        //   title: Text(
        //     'Beach Name',
        //     style: TextStyle(
        //       fontSize: 22,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   // bottom: PreferredSize(
        //   //   preferredSize: const Size.fromHeight(100),
        //   //   child: CalendarWidget(
        //   //     provider: provider,
        //   //   ),
        //   // ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF81D4FA),
                      Color(0xFF3DA0F1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40)),
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
                      // bottom: PreferredSize(
                      //   preferredSize: const Size.fromHeight(100),
                      //   child: CalendarWidget(
                      //     provider: provider,
                      //   ),
                      // ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ],
          ),
        ),
      );
    });
  }
}
