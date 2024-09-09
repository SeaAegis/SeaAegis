import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchBeachDetails(String beachName) async {
  final response =
      await http.get(Uri.parse('YOUR_API_ENDPOINT?query=$beachName'));

  if (response.statusCode == 200) {
    print(response);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load beach details');
  }
}
