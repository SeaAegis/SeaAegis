import 'package:flutter/material.dart';
// import 'package:seaaegis/views/beach_data/bottom_sheet/compass.dart';

class WindInformationSheet extends StatelessWidget {
  final List<Map<String, dynamic>> windData = [
    {
      'time': '11:00 AM',
      'speed': '12 kmph',
      'direction': 'North',
      'icon': Icons.north
    },
    {
      'time': '1:00 PM',
      'speed': '15 kmph',
      'direction': 'NorthEast',
      'icon': Icons.north_east
    },
    {
      'time': '3:00 PM',
      'speed': '10 kmph',
      'direction': 'East',
      'icon': Icons.east
    },
    {
      'time': '5:00 PM',
      'speed': '8 kmph',
      'direction': 'SouthEast',
      'icon': Icons.south_east
    },
    {
      'time': '7:00 PM',
      'speed': '20 kmph',
      'direction': 'South',
      'icon': Icons.south
    },
  ];

  WindInformationSheet({super.key});

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
                itemCount: windData.length,
                itemBuilder: (context, index) {
                  final data = windData[index];
                  return ListTile(
                    leading: Icon(data['icon'], color: Colors.blue),
                    title: Text('${data['time']}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 65,
                          child: Text(
                            '${data['speed']}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          width: 72,
                          child: Text(
                            textAlign: TextAlign.end,
                            data['direction'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
