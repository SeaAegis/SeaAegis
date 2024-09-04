import 'package:flutter/material.dart';

import 'package:smooth_compass/utils/src/compass_ui.dart';

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Compass',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SmoothCompass(
              rotationSpeed: 200,
              height: 300,
              width: 300,
            ),
          ),
        ],
      ),
    );
  }
}
