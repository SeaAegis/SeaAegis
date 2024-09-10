import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';

class WindInformationSheet extends StatelessWidget {
  // Accept wind data from the parent widget
  final List<BeachConditions>? conditionList;

  const WindInformationSheet({super.key, required this.conditionList});

  // Method to generate wind direction icon based on direction string
  IconData getWindDirectionIcon(String direction) {
    switch (direction.toLowerCase()) {
      case 'north':
        return Icons.north;
      case 'north-east':
        return Icons.north_east;
      case 'east':
        return Icons.east;
      case 'south-east':
        return Icons.south_east;
      case 'south':
        return Icons.south;
      case 'south-west':
        return Icons.south_west;
      case 'west':
        return Icons.west;
      case 'north-west':
        return Icons.north_west;
      default:
        return Icons.help_outline; // Default icon for unknown direction
    }
  }

  // Use the provided getDirectionFromDegrees function
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
                          content: Text('Get It in Next Update')));
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
            // Handle empty or null conditionList gracefully
            if (conditionList == null || conditionList!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No wind data available'),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: conditionList!.length,
                  itemBuilder: (context, index) {
                    final condition = conditionList![index];

                    // Ensure all required data is available
                    String time = formatTimeToIST(condition.time);
                    final String windSpeed = condition.windSpeedMps != null
                        ? '${condition.windSpeedMps!.toStringAsFixed(1)} km/h'
                        : 'N/A';

                    // Convert wind direction degrees to a string
                    final double? windDirectionDegrees =
                        condition.currentDirection;
                    final String windDirection = windDirectionDegrees != null
                        ? getDirectionFromDegrees(windDirectionDegrees)
                        : 'Unknown direction';

                    return ListTile(
                      leading: Icon(
                        getWindDirectionIcon(windDirection),
                        color: Colors.blue,
                      ),
                      title: Text(time.substring(10, 16),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 65,
                            child: Text(
                              windSpeed,
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
                              windDirection,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
