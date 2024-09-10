import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapLauncherDemo extends StatelessWidget {
  Future<void> openMapsSheet(BuildContext context) async {
    try {
      final coords = Coords(37.759392, -122.5107336);
      final title = "Ocean Beach";
      final availableMaps = await MapLauncher.installedMaps;

      print('Available Maps: $availableMaps'); // Debugging statement

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
                        print(
                            'Launching map: ${map.mapName}'); // Debugging statement
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
      print('Error: $e'); // Debugging statement
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
