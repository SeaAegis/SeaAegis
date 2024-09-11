import 'package:flutter/material.dart';

class WindDirection {
  static String getDirectionFromDegrees(double degrees) {
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

  static IconData getIconFromDirection(String direction) {
    switch (direction) {
      case 'North':
        return Icons.arrow_upward;
      case 'North-East':
        return Icons.north_east;
      case 'East':
        return Icons.arrow_forward;
      case 'South-East':
        return Icons.south_east;
      case 'South':
        return Icons.arrow_downward;
      case 'South-West':
        return Icons.south_west;
      case 'West':
        return Icons.arrow_back;
      case 'North-West':
        return Icons.north_west;
      default:
        return Icons.help; // Default icon if direction is unknown
    }
  }
}
