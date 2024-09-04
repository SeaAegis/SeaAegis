import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteStaticFinding extends StatefulWidget {
  final LatLng usercoordinates;
  final LatLng beachcoordinates;

  const RouteStaticFinding({
    super.key,
    required this.usercoordinates,
    required this.beachcoordinates,
  });

  @override
  State<RouteStaticFinding> createState() => _RouteStaticFindingState();
}

class _RouteStaticFindingState extends State<RouteStaticFinding> {
  late final CameraPosition initial;
  late final List<Marker> markerlist;
  final Completer<GoogleMapController> mapController = Completer();
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
    initial = CameraPosition(
      target: widget.beachcoordinates,
      zoom: 10.0,
    );
    markerlist = [
      Marker(
        markerId: const MarkerId("First"),
        position: widget.beachcoordinates,
        infoWindow: const InfoWindow(title: "User Location"),
      ),
      Marker(
        markerId: const MarkerId("Second"),
        position: widget.usercoordinates,
        infoWindow: const InfoWindow(title: "Beach Location"),
      ),
    ];
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
                setState(() {
                  isMapLoading = false;
                });
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
