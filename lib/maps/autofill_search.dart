import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutoFillMaps extends StatefulWidget {
  const AutoFillMaps({super.key});

  @override
  State<AutoFillMaps> createState() => _AutoFillMapsState();
}

class _AutoFillMapsState extends State<AutoFillMaps> {
  List<String> suggestions = [];

  void autocomplete(String input) async {
    const String apiKey = 'AIzaSyDRp4qnlAs4-XtomM4k0eep-pkrLLLU_Jo';
    const String language = 'en';
    const String types = '(beaches)';

    final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$input'
      '&key=$apiKey',
    );

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        List<String> newSuggestions = [];
        for (var prediction in data['predictions']) {
          newSuggestions.add(prediction['description']);
        }
        setState(() {
          suggestions = newSuggestions;
        });
      } else {
        print('Error: ${data['status']}');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Fill Maps'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autocomplete(value);
                } else {
                  setState(() {
                    suggestions.clear();
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Search for a place',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      print('Selected: ${suggestions[index]}');
                    },
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
