import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacesSearchScreen extends StatefulWidget {
  const PlacesSearchScreen({super.key});

  @override
  _PlacesSearchScreenState createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  String response = "";
  String beachname = "";
  String beachlocation = "";
  List<String> fsqid = [];
  List<String> icons = [];
  List<String> isopen = []; // Make this a list to handle multiple entries

  Future<void> fetchrequireddata(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.foursquare.com/v3/places/search?ll=$latitude,$longitude';
    const String authToken = 'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o=';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          fsqid.clear();
          icons.clear();
          isopen.clear();

          for (int i = 0; i < 10; i++) {
            var place = data["results"][i];
            
            fsqid.add(place["fsq_id"] ?? "Unknown ID");

            // Handling the "closed_bucket" field
            isopen.add(place["closed_bucket"] ?? "Unknown");

            // Handling the icon URL
            if (place["categories"].isNotEmpty) {
              var iconData = place["categories"][0]["icon"];
              var iconUrl = "${iconData["prefix"]}bg_64${iconData["suffix"]}";
              icons.add(iconUrl);
            } else {
              icons.add(const Icon(Icons.location_city).toString());
            }

            if (i == 0) {
              beachlocation = place["location"]["formatted_address"] ?? "Unknown Location";
              beachname = place["name"] ?? "Unknown Name";
            }
          }

        });
      }
    } catch (e) {
      setState(() {
        response = 'Error making GET request: $e';
      });
    }
  }

  Future<void> fetchphotos(String fsq_id)
  {
       final String apiUrl =
        'https://api.foursquare.com/v3/places/fsqi_id=$fsqi_id/photos?classifications=outdoor';
    const String authToken = 'fsq3OBnmL2pkxUCd5b9n8+HYJB5oFAVJikfii+RpnuOxw4o=';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': authToken,
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foursquare Places Search'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  fetchrequireddata(17.7142, 83.3237); 
                },
                child: const Text('Search Places'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    response.isNotEmpty
                        ? response
                        : 'Response will be shown here...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DraggableScrollableSheet(
              initialChildSize: 0.1, // Initial size when at the bottom
              minChildSize: 0.1, // Minimum size when collapsed
              maxChildSize: 0.95, // Maximum size when fully expanded
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: fsqid.isEmpty ? 0 : fsqid.length-1, 
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Center(
                          child: Icon(
                            Icons.drag_handle_outlined,
                            size: 30,
                          ),
                        );
                      }
                      int itemIndex = index;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            if (icons[itemIndex].isNotEmpty)
                              Image.network(
                                icons[itemIndex],
                                width: 40,
                                height: 40,
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fsqid[itemIndex]),
                                  Text(
                                    isopen[itemIndex],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
