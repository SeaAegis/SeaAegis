import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:seaaegis/app/app_providers.dart';
import 'package:seaaegis/firebase_options.dart';
import 'package:seaaegis/helpers/theme_data.dart';
import 'package:seaaegis/maps/mapsscreen.dart';
import 'package:seaaegis/maps/searchbar.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: AppProviders.providers,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SeaAeigs',
            themeMode: ThemeMode.system,
            theme: lightTheme.copyWith(
                textTheme: GoogleFonts.dmSansTextTheme(
              Theme.of(context).textTheme,
            )),
            // darkTheme: darkTheme.copyWith(
            //     textTheme: GoogleFonts.dmSansTextTheme(
            //   Theme.of(context).textTheme,
            // )),
            home: const MapsScreen(
              beachcoordinates: LatLng(17.71130271411997, 83.31716699306175),
              beachname: "Ramakrishna Beach",
            )));
  }
}
