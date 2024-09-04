import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:seaaegis/services/search/search_service.dart';
import 'package:seaaegis/views/beach_data/beach_stats.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String coordinates = "";
  TextEditingController placename = TextEditingController();
  List<dynamic> autocompleteResults = [];

  Future<void> getdetails() async {
    if (placename.text.isNotEmpty) {
      final res = await SearchService.searchLocation(placename.text);
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
        title: TextField(
          controller: placename,
          decoration: const InputDecoration(
              hintText: "Please enter Beach name",
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (String val) {
            fetchAutocompleteResults(val);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BeachStats()));
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
