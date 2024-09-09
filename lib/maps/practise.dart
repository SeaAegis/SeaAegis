import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapLauncherDemo extends StatelessWidget {
  // Function to open the map selection sheet
  Future<void> openMapsSheet(BuildContext context) async {
    try {
      // Define coordinates and title for the marker
      final coords = Coords(37.759392, -122.5107336);
      final title = "Ocean Beach";

      // Get the list of installed maps
      final availableMaps = await MapLauncher.installedMaps;

      // Show modal bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () async {
                        // Show marker in selected map
                        await map.showMarker(
                          coords: coords,
                          title: title,
                        );
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Launcher Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => openMapsSheet(context),
            child: Text('Show Maps'),
          ),
        ),
      ),
    );
  }
}
