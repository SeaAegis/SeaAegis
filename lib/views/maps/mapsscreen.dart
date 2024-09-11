import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seaaegis/model/beach.dart';
import 'package:seaaegis/widgets/basic_app_bar.dart';

import 'widgets/selectedbeachdata.dart';

class MapsScreen extends StatefulWidget {
  final LatLng beachcoordinates;
  final String beachname;
  final BeachDetails details;
  const MapsScreen({
    super.key,
    required this.beachcoordinates,
    required this.beachname,
    required this.details,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late CameraPosition initial;
  late List<Marker> markerlist;
  Completer<GoogleMapController> mapController = Completer();
  bool isMapLoading = true;
  bool isFocusOnbeach = true;
  LatLng? userLocation = const LatLng(16.566222371638474, 81.5225554105058);

  @override
  void initState() {
    super.initState();
    getUserLocation();
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
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   userLocation = LatLng(position.latitude, position.longitude);
    // });

    // updateMapData();
  }

  @override
  void didUpdateWidget(MapsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.beachcoordinates != oldWidget.beachcoordinates) {
      updateMapData();
    }
  }

  void updateMapData() async {
    setState(() {
      isMapLoading = true;
    });

    initial = CameraPosition(
      target: widget.beachcoordinates,
      zoom: 10.0,
    );

    markerlist = [
      Marker(
        markerId: const MarkerId("Beach"),
        position: widget.beachcoordinates,
        infoWindow: InfoWindow(title: widget.beachname),
      ),
      if (userLocation != null)
        Marker(
          markerId: const MarkerId("User"),
          position: userLocation!,
          infoWindow: const InfoWindow(
              title: "Vishnu Institute of Technology, Bhimavaram"),
        ),
    ];

    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initial));

    setState(() {
      isMapLoading = false;
    });
  }

  void toggleFocus() async {
    final controller = await mapController.future;
    CameraPosition targetPosition = isFocusOnbeach
        ? CameraPosition(target: widget.beachcoordinates, zoom: 10.0)
        : CameraPosition(target: userLocation!, zoom: 10.0);

    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));

    setState(() {
      isFocusOnbeach = !isFocusOnbeach;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Column(
          children: [
            Text(
              widget.details.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${widget.details.district}, ${widget.details.state}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
            Positioned(
              bottom: 70.0,
              right: 60.0,
              child: FloatingActionButton(
                onPressed: toggleFocus,
                tooltip: 'Toggle Focus',
                child: Icon(isFocusOnbeach ? Icons.location_on : Icons.map),
              ),
            ),
            SelectedBeachData(
              beachcoor: widget.beachcoordinates,
            )
          ],
        ),
      ),
    );
  }
}
