import 'dart:convert';
import 'package:http/http.dart' as http;

// Define safety thresholds
const double minAirTempC = 18.0;
const double maxAirTempC = 32.0;
const double maxWaterTempC = 32.0;
const double maxWindSpeedMps = 7.0;
const double maxWaveHeightM = 2.0;
const double maxSwellHeightM = 2.0;
const double minVisibilityKm = 5.0;
const double maxHumidity = 80.0;
const double maxPrecipitation = 1;
const double minPressure = 1000.0;

class BeachConditions {
  final double airTempC;
  final double waterTempC;
  final double windSpeedMps;
  final double waveHeightM;
  final double swellHeightM;
  final double visibilityKm;
  final double humidity;
  final double precipitation;
  final double pressure;
  final double currentDirection;
  final DateTime time;

  BeachConditions({
    required this.airTempC,
    required this.waterTempC,
    required this.windSpeedMps,
    required this.waveHeightM,
    required this.swellHeightM,
    required this.visibilityKm,
    required this.humidity,
    required this.precipitation,
    required this.pressure,
    required this.time,
    required this.currentDirection,
  });

  bool isSafeToVisit() {
    return airTempC >= minAirTempC &&
        airTempC <= maxAirTempC &&
        waterTempC <= maxWaterTempC &&
        windSpeedMps <= maxWindSpeedMps &&
        waveHeightM <= maxWaveHeightM &&
        swellHeightM <= maxSwellHeightM &&
        visibilityKm >= minVisibilityKm &&
        humidity <= maxHumidity &&
        precipitation <= maxPrecipitation &&
        pressure >= minPressure;
  }

  String getSafetyIssues() {
    List<String> issues = [];
    if (airTempC < minAirTempC || airTempC > maxAirTempC) {
      issues.add('Air temperature is outside the safe range.');
    }
    if (waterTempC > maxWaterTempC) {
      issues.add('Water temperature is too high.');
    }
    if (windSpeedMps > maxWindSpeedMps) issues.add('Wind speed is too high.');
    if (waveHeightM > maxWaveHeightM) issues.add('Wave height is too high.');
    if (swellHeightM > maxSwellHeightM) issues.add('Swell height is too high.');
    if (visibilityKm < minVisibilityKm) issues.add('Visibility is too low.');
    if (humidity > maxHumidity) issues.add('Humidity is too high.');
    if (precipitation >= maxPrecipitation) {
      issues.add('Precipitation is too high.');
    }
    if (pressure < minPressure) issues.add('Pressure is too low.');

    return issues.isEmpty
        ? 'The beach conditions are safe for a visit.'
        : ' ${issues.join(' ')}';
  }
}

Future<List<BeachConditions>> fetchBeachConditions(
    double lat, double lng) async {
  const String params =
      'waveHeight,airTemperature,windSpeed,visibility,humidity,waterTemperature,swellHeight,swellDirection,swellPeriod,precipitation,pressure,currentDirection';
  final String url =
      'https://api.stormglass.io/v2/weather/point?lat=$lat&lng=$lng&params=$params';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          // 'd41eba2c-6a02-11ef-9acf-0242ac130004-d41eba90-6a02-11ef-9acf-0242ac130004',//used
          '88279bf2-6fed-11ef-aa85-0242ac130004-88279c9c-6fed-11ef-aa85-0242ac130004',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hours = data['hours'];
      DateTime now = DateTime.now().toUtc();

      List<BeachConditions> conditionsList = [];
      for (var hour in hours) {
        // DateTime time = DateTime.parse(hour['time']);
        DateTime utcDateTime = DateTime.parse(hour['time']).toUtc();

        // Add 5 hours and 30 minutes to convert to IST
        DateTime istDateTime =
            utcDateTime.add(const Duration(hours: 5, minutes: 30));
        if (istDateTime.isAfter(now)) {
          final double airTempC =
              (hour['airTemperature']?['noaa'] as num?)?.toDouble() ?? 22.0;
          final double waterTempC =
              (hour['waterTemperature']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double windSpeedMps =
              (hour['windSpeed']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double waveHeightM =
              (hour['waveHeight']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double swellHeightM =
              (hour['swellHeight']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double visibilityKm =
              (hour['visibility']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double humidity =
              (hour['humidity']?['noaa'] as num?)?.toDouble() ?? 0.0;
          final double precipitation =
              ((hour['precipitation']?['noaa'] as num?)?.toDouble() ?? 0.0);
          final double pressure =
              (hour['pressure']?['noaa'] as num?)?.toDouble() ?? 1013.0;
          final double currentDirection =
              (hour['currentDirection']?['meto']) ?? 0;

          conditionsList.add(BeachConditions(
              airTempC: airTempC,
              waterTempC: waterTempC,
              windSpeedMps: windSpeedMps,
              waveHeightM: waveHeightM,
              swellHeightM: swellHeightM,
              visibilityKm: visibilityKm,
              humidity: humidity,
              precipitation: precipitation,
              pressure: pressure,
              time: istDateTime,
              currentDirection: currentDirection));
        }
      }
      return conditionsList;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
    rethrow;
  }
}

String formatTimeToIST(DateTime utcTime) {
  return utcTime.add(const Duration(hours: 5, minutes: 30)).toString();
}

BeachConditions? findNextSafeHour(
    List<BeachConditions> conditionsList, int startIndex) {
  // Loop through the list starting from the provided index
  for (var i = startIndex; i < conditionsList.length; i++) {
    if (conditionsList[i].isSafeToVisit()) {
      return conditionsList[i]; // Return the first safe condition found
    }
  }
  return null; // Return null if no safe condition is found
}
