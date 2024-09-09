// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> searchLocation(String query) async {
//   final url =
//       'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     // Handle data to check if it's a beach or find nearby beaches
//     print(searchLocation);
//     print(data);
//   } else {
//     // Handle error
//   }
// }

// Future<void> findNearbyBeaches(double lat, double lon) async {
//   final overpassUrl =
//       'https://overpass-api.de/api/interpreter?data=[out:json];node(around:50000,$lat,$lon)["natural"="beach"];out;';
//   final response = await http.get(Uri.parse(overpassUrl));

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     // Handle data to list nearby beaches
//     print(findNearbyBeaches);
//     print(data);
//   } else {
//     // Handle error
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> searchLocation(String query) async {
  final url =
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data); // Return list of results
  } else {
    return []; // Return empty list on error
  }
}

Future<List<Map<String, dynamic>>> findNearbyBeaches(
    double lat, double lon) async {
  final overpassUrl =
      'https://overpass-api.de/api/interpreter?data=[out:json];node(around:50000,$lat,$lon)["natural"="beach"];out;';
  final response = await http.get(Uri.parse(overpassUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final elements = data['elements'] as List;
    return elements
        .map((e) => e as Map<String, dynamic>)
        .toList(); // Return list of beaches
  } else {
    return []; // Return empty list on error
  }
}
