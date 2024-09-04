import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seaaegis/maps/google_maps.dart';

class DemoSearchbar extends StatefulWidget {
  const DemoSearchbar({super.key});

  @override
  State<DemoSearchbar> createState() => _DemoSearchbarState();
}

class _DemoSearchbarState extends State<DemoSearchbar> {
  String beach="";
  String user="";
  LatLng? usercoor;
  LatLng? beachcoor;
  TextEditingController placename = TextEditingController();

  //user Location
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

  // Get Beach Location
  getdetails() async {
    if (placename.text.isNotEmpty) {
      List<Location> latlon = await locationFromAddress(placename.text);
      beach = "${latlon.last.latitude},${latlon.last.longitude}";
      beachcoor = LatLng(latlon.last.latitude, latlon.last.longitude);
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
          Text("Beach Cordinates $beach"),
          const SizedBox(
            height: 20,
          ),
          Text("User Cordinates $user"),
          const SizedBox(height: 20,),

          if(usercoor !=null && beachcoor !=null)
              RouteStaticFinding(
              usercoordinates: usercoor!,
              beachcoordinates: beachcoor!,
          ),
              
            ],
          )
          
    );
  }
}
