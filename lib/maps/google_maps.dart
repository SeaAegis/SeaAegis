import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator

class RouteStaticFinding extends StatefulWidget {
  final LatLng beachcoordinates;

  const RouteStaticFinding({
    super.key,
    required this.beachcoordinates,
  });

  @override
  State<RouteStaticFinding> createState() => _RouteStaticFindingState();
}

class _RouteStaticFindingState extends State<RouteStaticFinding> {
  late CameraPosition initial;
  late List<Marker> markerlist;
  Completer<GoogleMapController> mapController = Completer();
  bool isMapLoading = true;
  LatLng? userLocation = LatLng(16.566222371638474, 81.5225554105058);

  @override
  void initState() {
    super.initState();
    getUserLocation(); // Fetch user location on init
    updateMapData();
  }

  // Function to get user location
  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

    updateMapData();
  }

  @override
  void didUpdateWidget(RouteStaticFinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.beachcoordinates != oldWidget.beachcoordinates) {
      updateMapData();
    }
  }

  void updateMapData() async {
    setState(() {
      isMapLoading = true;
    });

    // If userLocation is not yet fetched, use the beach location as initial
    initial = CameraPosition(
      target: userLocation ?? widget.beachcoordinates,
      zoom: 10.0,
    );

    markerlist = [
      Marker(
        markerId: const MarkerId("Beach"),
        position: widget.beachcoordinates,
        infoWindow: const InfoWindow(title: "Beach Location"),
      ),
      if (userLocation != null)
        Marker(
          markerId: const MarkerId("User"),
          position: userLocation!,
          infoWindow: const InfoWindow(title: "User Location"),
        ),
    ];

    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initial));

    setState(() {
      isMapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 300.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initial,
            markers: Set<Marker>.of(markerlist),
            onMapCreated: (controller) {
              mapController.complete(controller);
            },
          ),
          if (isMapLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
