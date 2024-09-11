import 'package:flutter/material.dart';

class WaveHeightConditions {
  // Function to get wave condition based on height in meters
  static String getWaveCondition(double heightInMeters) {
    if (heightInMeters <= 1.0) {
      return 'Low';
    } else if (heightInMeters > 1.0 && heightInMeters <= 3.0) {
      return 'Moderate';
    } else {
      return 'High';
    }
  }

  // Function to get color based on wave height condition
  static Color getColorForWaveCondition(double heightInMeters) {
    String condition = getWaveCondition(heightInMeters);

    switch (condition) {
      case 'Low':
        return Colors.green; // Green for Low wave height
      case 'Moderate':
        return const Color(0xFFF1E363); // Yellow for Moderate wave height
      case 'High':
        return Colors.red; // Red for High wave height
      default:
        return Colors.grey; // Default color if condition is unknown
    }
  }

  static IconData getIconForWaveCondition(double heightInMeters) {
    String condition = getWaveCondition(heightInMeters);

    switch (condition) {
      case 'Low':
        return Icons.arrow_downward;
      case 'Moderate':
        return Icons.waves;
      case 'High':
        return Icons.arrow_upward;
      default:
        return Icons.waves;
    }
  }
}
