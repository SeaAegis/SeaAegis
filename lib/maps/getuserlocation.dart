import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  LocationExampleState createState() => LocationExampleState();
}

class LocationExampleState extends State<LocationExample> {
  Future<Position> _determinePosition() async {
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

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              Position position = await _determinePosition();
              print('Location: ${position.latitude}, ${position.longitude}');

              
            } catch (e) {
              print('Error: $e');
            }
          },
          child: const Text('Get Location'),
        ),
      ),
    );
  }
}
