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
  late CameraPosition initial;
  late List<Marker> markerlist;
  Completer<GoogleMapController> mapController = Completer();
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
    updateMapData();
  }

  @override
  void didUpdateWidget(RouteStaticFinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.usercoordinates != oldWidget.usercoordinates ||
        widget.beachcoordinates != oldWidget.beachcoordinates) {
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
        markerId: const MarkerId("First"),
        position: widget.beachcoordinates,
        infoWindow: const InfoWindow(title: "Beach Location"),
      ),
      const Marker(
        markerId: MarkerId("Second"),
        position: LatLng(16.568832268152413, 81.52601929516328),
        infoWindow: InfoWindow(title: "User Location"),
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
            // markers: Set<Marker>.of(markerlist),
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
