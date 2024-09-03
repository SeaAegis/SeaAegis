import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seaaegis/firebase_options.dart';
import 'package:seaaegis/screens/auth/signin.dart';
import 'package:seaaegis/screens/home/google_maps.dart';
// import 'package:seaaegis/screens/home/searchbar.dart';

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
    return const MaterialApp(
      home: RouteStaticFinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
