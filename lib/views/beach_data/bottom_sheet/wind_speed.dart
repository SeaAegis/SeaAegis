import 'package:flutter/material.dart';
import 'package:seaaegis/services/weather/wind_direction.dart';
import 'package:seaaegis/testApi/tester1.dart';
// import 'package:seaaegis/views/beach_data/bottom_sheet/compass.dart';

class WindInformationSheet extends StatelessWidget {
  final List<BeachConditions> conditionList;

  const WindInformationSheet({super.key, required this.conditionList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0).copyWith(bottom: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wind Information',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Get It in Next Update ')));
                      // showBottomSheet(
                      //   context: context,
                      //   showDragHandle: true,
                      //   builder: (context) => const CompassScreen(),
                      // );
                    },
                    child: const Text('Show Compass'))
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
                  SizedBox(
                    width: 65,
                    child: Text(
                      'Speed',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Direction',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: conditionList.length,
                itemBuilder: (context, index) {
                  // final data = windData[index];
                  final data = conditionList[index];
                  String direction = WindDirection.getDirectionFromDegrees(
                      data.currentDirection);
                  final bool isNewDay = index == 0 ||
                      (data.time.day != conditionList[index - 1].time.day);
                  return Column(
                    children: [
                      if (isNewDay)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            "${data.time.day}/${data.time.month}/${data.time.year}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ListTile(
                        leading: Icon(
                            WindDirection.getIconFromDirection(direction),
                            color: Colors.blue),
                        title: Text('${data.time.hour}:${data.time.minute}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                '${data.windSpeedMps} Mps',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(
                                textAlign: TextAlign.end,
                                direction,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black54,
                                  fontSize: 14,
                                ),
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
      ),
    );
  }
}
