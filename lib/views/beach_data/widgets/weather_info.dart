import 'package:flutter/material.dart';
import 'package:seaaegis/views/beach_data/bottom_sheet/wave_heights.dart';
import 'package:seaaegis/views/beach_data/bottom_sheet/wind_speed.dart';

class WeatherInfoGrid extends StatelessWidget {
  final double windSpeed;
  final String windDirection;
  final double waveHeight;
  final double visibility;
  final double precipitation;
  final double humidity;

  const WeatherInfoGrid({
    super.key,
    required this.windSpeed,
    required this.windDirection,
    required this.waveHeight,
    required this.visibility,
    required this.precipitation,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // height: 600,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF81D4FA),
                Color(0xFF44A7F7),
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
        child: GridView.count(
          crossAxisCount: 3, // 3 columns
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            WeatherInfoCard(
              onTap: () => showModalBottomSheet(
                // sheetAnimationStyle: AnimationStyle(
                //   curve: Curves.easeIn,
                // ),

                showDragHandle: true,
                context: context,
                builder: (context) => WindInformationSheet(),
              ),
              icon: Icons.air,
              value: '$windSpeed km/h',
              label: 'Wind Speed',
            ),
            WeatherInfoCard(
              onTap: () => showModalBottomSheet(
                // sheetAnimationStyle: AnimationStyle(
                //   curve: Curves.easeIn,
                // ),

                showDragHandle: true,
                context: context,
                builder: (context) => WindInformationSheet(),
              ),
              icon: Icons.explore, // or use a custom icon for wind direction
              value: windDirection,
              label: 'Wind Direction',
            ),
            WeatherInfoCard(
              onTap: () => showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) => WaveHeights(),
              ),
              icon: Icons.waves,
              value: '${waveHeight.toStringAsFixed(1)} m',
              label: 'Wave Height',
            ),
            WeatherInfoCard(
              icon: Icons.visibility,
              value: '${visibility.toStringAsFixed(1)} km',
              label: 'Visibility',
            ),
            WeatherInfoCard(
              icon: Icons.grain,
              value: '${precipitation.toStringAsFixed(1)} mm',
              label: 'Precipitation',
            ),
            WeatherInfoCard(
              icon: Icons.water_drop,
              value: '${humidity.toStringAsFixed(1)}%',
              label: 'Humidity',
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Function()? onTap;
  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
