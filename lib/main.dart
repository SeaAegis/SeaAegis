import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seaaegis/app/app_providers.dart';
import 'package:seaaegis/firebase_options.dart';

// import 'package:seaaegis/views/home/google_maps.dart';
// import 'package:seaaegis/screens/home/searchbar.dart';
import 'package:seaaegis/helpers/theme_data.dart';
import 'package:seaaegis/screens/home/userselection.dart';
import 'package:seaaegis/views/auth/user/login.dart';
import 'package:seaaegis/views/home/home.dart';
import 'routes/routes.dart';

// import 'package:seaaegis/views/home/widgets/searchbar.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
  // Handle background message here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
        // themeMode: ThemeMode.system,
        theme: appTheme.copyWith(
            textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        )),
        // darkTheme: darkTheme.copyWith(
        //     textTheme: GoogleFonts.dmSansTextTheme(
        //   Theme.of(context).textTheme,
        // )),
        home: Userselection(),
        // home: const BeachStats(),
      ),
    );
  }
}
