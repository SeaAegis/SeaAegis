import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';

import 'package:seaaegis/services/search_service.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  String coordinates = "";
  TextEditingController placename = TextEditingController();
  getdetails() async {
    if (placename.text.isNotEmpty) {
      List<Location> latlon = await locationFromAddress(placename.text);
      final res = await searchLocation(placename.text);
      print("search location $res");
      coordinates = "${latlon.last.latitude},${latlon.last.longitude}";
      final res1 =
          await findNearbyBeaches(latlon.last.latitude, latlon.last.longitude);
      print("findNearbyBeaches $res1");
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
          ),
          ElevatedButton(onPressed: getdetails, child: const Text("click me")),
          const SizedBox(
            height: 20,
          ),
          Text(coordinates),
          SearchGooglePlacesWidget(
            placeType: PlaceType
                .region, // PlaceType.cities, PlaceType.geocode, PlaceType.region etc
            placeholder: 'Enter the address',
            apiKey: 'Your Google Map API Key goes here',
            onSearch: (Place place) {},
            onSelected: (Place place) async {
              print('address ${place.description}');
            },
          ),
        ],
      ),
    );
  }
}
