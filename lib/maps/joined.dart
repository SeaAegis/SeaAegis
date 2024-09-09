import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seaaegis/maps/google_maps.dart';
import 'package:seaaegis/services/search_service.dart';

class Joined extends StatefulWidget {
  const Joined({super.key});

  @override
  State<Joined> createState() => _JoinedState();
}

class _JoinedState extends State<Joined> {
  String beach = "";
  String user = "";
  LatLng? usercoor;
  LatLng? beachcoor;
  String coordinates = "";
  TextEditingController placename = TextEditingController();
  List<dynamic> autocompleteResults = [];

  // Fetch User Location
  Future<Position> getuserlocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Fetch Beach Location
  getdetails() async {
    if (placename.text.isNotEmpty) {
      final res = await searchLocation(placename.text);
      beachcoor = LatLng(
          double.tryParse(res[0]['lat'])!, double.tryParse(res[0]['lon'])!);
      print(beachcoor);
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
      return;
    }
    setState(() {});
  }

  // Fetch Autocomplete Results
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
  void initState() {
    super.initState();
    getuserlocation().then((value) {
      user = "${value.latitude},${value.longitude}";
      usercoor = LatLng(value.latitude, value.longitude);
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TextField(
          controller: placename,
          decoration: const InputDecoration(
              hintText: "Please enter Beach name",
              hintStyle: TextStyle(
                color: Colors.white,
              )),
        ),
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
                return ListTile(
                  title: Text(result['display_name']),
                  onTap: () {
                    setState(() {
                      placename.text = result['display_name'];
                      coordinates = "${result['lat']},${result['lon']}";
                      beachcoor = LatLng(double.parse(result['lat']),
                          double.parse(result['lon']));
                    });

                    // Navigate to the map screen with the selected beach coordinates
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteStaticFinding(
                          beachcoordinates: beachcoor!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
