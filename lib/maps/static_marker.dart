import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends StatefulWidget {
  const CustomMarker({super.key});

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  final CameraPosition initial = const CameraPosition(
    target: LatLng(16.547370218933096, 81.51819666166557),
    zoom: 15.0,
    );
  final Completer<GoogleMapController> mapController =Completer();
  List<Marker> mymarkers=[];
  List<Marker> markerlist =[
    const Marker(markerId:MarkerId("First"),
    position: LatLng(16.547370218933096, 81.51819666166557),
    infoWindow: InfoWindow(
      title: "Bhimavaram"
    ) ),
    const Marker(markerId:MarkerId("Second"),
    position: LatLng(16.52390390949731, 81.70779065332044),
    infoWindow: InfoWindow(
      title: "Palakollu"
    ) ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: initial,
          markers: Set<Marker>.of(markerlist),
          onMapCreated: (controller) {
            mapController.complete(controller);
          },
        )
      ),
    );
  }
}