import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this package for handling settings redirection

class UserCurrentLocation extends StatefulWidget {
  @override
  _UserCurrentLocationState createState() => _UserCurrentLocationState();
}

class _UserCurrentLocationState extends State<UserCurrentLocation> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  late Location location;
  bool isMapLoading = true;

  @override
  void initState() {
    super.initState();
    location = Location();
    checkPermissionsAndGetLocation();
  }

  // Function to check permissions and get user location
  Future<void> checkPermissionsAndGetLocation() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      _showPermissionDeniedDialog();
      return;
    }

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.deniedForever) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      getUserLocation();
    }
  }

  // Function to get user location
  Future<void> getUserLocation() async {
    final currentLocationData = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(
        currentLocationData.latitude!,
        currentLocationData.longitude!,
      );
      isMapLoading = false;
    });
    if (_controller.isCompleted) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation!,
          zoom: 14.0,
        ),
      ));
    }
  }

  // Show a dialog to direct users to open app settings
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
            "Location permission is permanently denied. Please enable it in app settings."),
        actions: [
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () async {
              await openAppSettings(); // Open app settings using permission_handler package
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Current Location'),
      ),
      body: isMapLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              myLocationEnabled: true,
            ),
    );
  }
}
