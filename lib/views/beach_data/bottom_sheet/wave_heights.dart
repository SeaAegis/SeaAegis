import 'package:flutter/material.dart';

import 'wave_heights_graph.dart';

class WaveHeights extends StatelessWidget {
  final List<Map<String, String>> tideData = [
    {'time': '11:59 AM', 'height': '4.3 ft', 'type': 'High'},
    {'time': '12:50 AM', 'height': '5.3 ft', 'type': 'High'},
    {'time': '5:53 PM', 'height': '1.3 ft', 'type': 'Low'},
    {'time': '7:35 PM', 'height': '1.8 ft', 'type': 'Low'},
    {'time': '9:23 PM', 'height': '5.8 ft', 'type': 'High'},
  ];

  WaveHeights({super.key});

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
                          builder: (context) => TideChartBottomSheet()),
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
                      width: 24,
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
                  itemCount: tideData.length,
                  itemBuilder: (context, index) {
                    final data = tideData[index];
                    return ListTile(
                      leading: Icon(
                        data['type'] == 'High'
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color:
                            data['type'] == 'High' ? Colors.red : Colors.green,
                      ),
                      title: Text(data['time'] ?? '',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${data['height']}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Text(
                            data['type'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: data['type'] == 'High'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
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
        ));
  }
}
