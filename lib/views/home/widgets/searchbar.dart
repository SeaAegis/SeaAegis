import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:seaaegis/services/search_service.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  String coordinates = "";
  TextEditingController placename = TextEditingController();
  List<dynamic> autocompleteResults = [];

  Future<void> getdetails() async {
    if (placename.text.isNotEmpty) {
      final res = await searchLocation(placename.text);
      print("Searched coordinaes : res[0]['display_name']");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Please enter Beach name'),
          );
        },
      );
    }
  }

  Future<void> fetchAutocompleteResults(String query) async {
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      setState(() {
        autocompleteResults = res;
      });
    } else {
      throw Exception('Failed to load autocomplete results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beach Coordinates"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: placename,
            decoration: const InputDecoration(
              labelText: "Beach Name",
              hintText: "Please enter Beach name",
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            onChanged: (String val) {
              fetchAutocompleteResults(val);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: autocompleteResults.length,
              itemBuilder: (context, index) {
                var result = autocompleteResults[index];
                return Container(
                    child: ListTile(
                  title: Text(result['display_name']),
                  onTap: () {
                    setState(() {
                      placename.text = result['display_name'];
                      coordinates = "${result['lat']},${result['lon']}";
                    });
                  },
                ));
              },
            ),
          ),
          Text(coordinates),
        ],
      ),
    );
  }
}
