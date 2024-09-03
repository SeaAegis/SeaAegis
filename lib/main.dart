import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seaaegis/app/app_providers.dart';
import 'package:seaaegis/firebase_options.dart';

// import 'package:seaaegis/views/home/google_maps.dart';
// import 'package:seaaegis/screens/home/searchbar.dart';
import 'package:seaaegis/helpers/theme_data.dart';
import 'package:seaaegis/maps/getuserlocation.dart';
import 'package:seaaegis/views/home/home.dart';
import 'package:seaaegis/views/home/widgets/searchbar.dart';
// import 'package:seaaegis/views/home/widgets/searchbar.dart';

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
        home: Translator(),
      ),
    );
  }
}
