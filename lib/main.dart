import 'package:flutter/material.dart';
import 'package:lesson_72_permissions/services/location_service.dart';
import 'package:lesson_72_permissions/views/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blueAccent),
      home: const MapScreen(),
    );
  }
}
