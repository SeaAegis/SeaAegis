import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

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
      print(latlon);
      coordinates = "${latlon.last.latitude},${latlon.last.longitude}";
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
        ],
      ),
    );
  }
}
