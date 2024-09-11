import 'package:flutter/material.dart';
import 'package:seaaegis/services/weather/wave_heights_conditions.dart';
import 'package:seaaegis/testApi/tester1.dart';

import 'wave_heights_graph.dart';

class WaveHeights extends StatelessWidget {
  final List<BeachConditions> conditionList;

  // final List<Map<String, String>> tideData = [
  //   {'time': '11:59 AM', 'height': '4.3 ft', 'type': 'High'},
  //   {'time': '12:50 AM', 'height': '5.3 ft', 'type': 'High'},
  //   {'time': '5:53 PM', 'height': '1.3 ft', 'type': 'Low'},
  //   {'time': '7:35 PM', 'height': '1.8 ft', 'type': 'Low'},
  //   {'time': '9:23 PM', 'height': '5.8 ft', 'type': 'High'},
  // ];

  const WaveHeights({super.key, required this.conditionList});

  @override
  Widget build(BuildContext context) {
    print(conditionList.length);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0).copyWith(bottom: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today\'s Tide',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () => showBottomSheet(
                          showDragHandle: true,
                          context: context,
                          builder: (context) => TideChartBottomSheet(
                                conditionList: conditionList,
                              )),
                      child: const Text('Graph View'))
                ],
              ),
              const Divider(),
              const ListTile(
                leading: SizedBox(),
                title: Text(
                  'Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Height',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: conditionList.length,
                  itemBuilder: (context, index) {
                    final waveData = conditionList[index];
                    final bool isNewDay = index == 0 ||
                        (waveData.time.day !=
                            conditionList[index - 1].time.day);

                    // print(waveData.time
                    //     .add(const Duration(hours: 5, minutes: 30)));
                    return Column(
                      children: [
                        if (isNewDay)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              "${waveData.time.day}/${waveData.time.month}/${waveData.time.year}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ListTile(
                          leading: Icon(
                              WaveHeightConditions.getIconForWaveCondition(
                                  waveData.waveHeightM),
                              color:
                                  WaveHeightConditions.getColorForWaveCondition(
                                      waveData.waveHeightM)),
                          title: Text(
                              '${waveData.time.hour}:${waveData.time.minute}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${waveData.waveHeightM} M',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                WaveHeightConditions.getWaveCondition(
                                    waveData.waveHeightM),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: WaveHeightConditions
                                      .getColorForWaveCondition(
                                          waveData.waveHeightM),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
