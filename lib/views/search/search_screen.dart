import 'package:flutter/material.dart';
import 'package:seaaegis/model/beach.dart';
import 'package:seaaegis/services/search/search_service.dart';
import 'package:seaaegis/testApi/tester1.dart';
import 'package:seaaegis/views/beach_data/beach_stats.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String coordinates = "";
  TextEditingController placename = TextEditingController();
  List<dynamic> autocompleteResults = [];
  late BeachDetails beachDetails;
  Future<void> getdetails() async {
    if (placename.text.isNotEmpty) {
      final res = await SearchService.searchLocation(placename.text);
      print("Searched coordinates: ${res[0]['display_name']}");
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
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=3',
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

  void _onLocationSelected(double lat, double lon) async {
    try {
      List<BeachConditions> conditionsList =
          await fetchBeachConditions(lat, lon);
      BeachConditions currentCondition = conditionsList.first;
      // print('navigation');
      print(conditionsList);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BeachStats(
            beachConditions: currentCondition,
            conditionList: conditionsList,
            beachDetails: beachDetails,
          ),
        ),
      );
      setState(() {});
    } catch (e) {
      print('Error fetching beach conditions: $e');
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
                return ListTile(
                  title: Text(result['display_name']),
                  onTap: () {
                    print(result);
                    setState(() {
                      beachDetails = BeachDetails.fromJson(result);
                      // print(beachDetails.name);
                      coordinates = "${result['lat']},${result['lon']}";

                      double lat = double.parse(result['lat']);
                      double lon = double.parse(result['lon']);
                      _onLocationSelected(lat, lon);
                    });
                  },
                );
              },
            ),
          ),
          Text(coordinates),
        ],
      ),
    );
  }
}
