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
const double maxHumidity = 90.0;
const double maxPrecipitation = 1; // Example threshold for precipitation
const double minPressure = 1000.0; // Example threshold for pressure in hPa

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
  });

  bool isSafeToVisit() {
    bool temperatureSafe = airTempC >= minAirTempC && airTempC <= maxAirTempC;
    bool waterTemperatureSafe = waterTempC <= maxWaterTempC;
    bool windSpeedSafe = windSpeedMps <= maxWindSpeedMps;
    bool waveHeightSafe = waveHeightM <= maxWaveHeightM;
    bool swellHeightSafe = swellHeightM <= maxSwellHeightM;
    bool visibilitySafe = visibilityKm >= minVisibilityKm;
    bool humiditySafe = humidity <= maxHumidity;
    bool precipitationSafe = precipitation <= maxPrecipitation;
    bool pressureSafe = pressure >= minPressure;

    return temperatureSafe &&
        waterTemperatureSafe &&
        windSpeedSafe &&
        waveHeightSafe &&
        swellHeightSafe &&
        visibilitySafe &&
        humiditySafe &&
        precipitationSafe &&
        pressureSafe;
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
        : 'The beach conditions are not suitable for a visit due to: ${issues.join(' ')}.';
  }
}

Future<List<BeachConditions>> fetchBeachConditions(
    double lat, double lng) async {
  const String params =
      'waveHeight,airTemperature,windSpeed,visibility,humidity,waterTemperature,swellHeight,swellDirection,swellPeriod,precipitation,pressure';
  final String url =
      'https://api.stormglass.io/v2/weather/point?lat=$lat&lng=$lng&params=$params';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          '63f57188-69cf-11ef-a732-0242ac130004-63f571f6-69cf-11ef-a732-0242ac130004',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hours = data['hours'];
      DateTime now = DateTime.now().toUtc();

      List<BeachConditions> conditionsList = [];
      for (var hour in hours) {
        DateTime time = DateTime.parse(hour['time']);
        if (time.isAfter(now)) {
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
            time: time,
          ));
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

BeachConditions? findNextSafeHour(List<BeachConditions> conditionsList) {
  for (var condition in conditionsList) {
    if (condition.isSafeToVisit()) {
      return condition;
    }
  }
  return null;
}

void main() async {
  try {
    print("Started");
    double lat = 17.801910;
    double lng = 83.397888;

    DateTime currentTime = DateTime.now().toUtc();
    print("Current IST Time: ${formatTimeToIST(currentTime)}");

    List<BeachConditions> conditionsList = await fetchBeachConditions(lat, lng);
    // print(conditionsList);
    var i = 1;
    for (var condition in conditionsList) {
      print(
          'Current Beach Conditions (Time: ${formatTimeToIST(condition.time)} IST):');
      print(i);
      print('airTempC: ${condition.airTempC}');
      print('waterTempC: ${condition.waterTempC}');
      print('windSpeedMps: ${condition.windSpeedMps}');
      print('waveHeightM: ${condition.waveHeightM}');
      print('swellHeightM: ${condition.swellHeightM}');
      print('visibilityKm: ${condition.visibilityKm}');
      print('humidity: ${condition.humidity}');
      print('precipitation: ${condition.precipitation}');
      print('pressure: ${condition.pressure}\n\n');
      i++;
    }

    BeachConditions currentConditions = conditionsList.first;
    print(
        'Current Beach Conditions (Time: ${formatTimeToIST(currentConditions.time)} IST):');
    print('airTempC: ${currentConditions.airTempC}');
    print('waterTempC: ${currentConditions.waterTempC}');
    print('windSpeedMps: ${currentConditions.windSpeedMps}');
    print('waveHeightM: ${currentConditions.waveHeightM}');
    print('swellHeightM: ${currentConditions.swellHeightM}');
    print('visibilityKm: ${currentConditions.visibilityKm}');
    print('humidity: ${currentConditions.humidity}');
    print('precipitation: ${currentConditions.precipitation}');
    print('pressure: ${currentConditions.pressure}');

    String safetyMessage = currentConditions.getSafetyIssues();
    print(safetyMessage);

    if (!currentConditions.isSafeToVisit()) {
      BeachConditions? bestTimeCondition = findNextSafeHour(conditionsList);
      if (bestTimeCondition != null) {
        print(
            'The best time to visit is at ${formatTimeToIST(bestTimeCondition.time)} IST.');
      } else {
        print('No safe time to visit in the near future.');
      }
    }
  } catch (e) {
    print('Error is: $e');
  }
}
