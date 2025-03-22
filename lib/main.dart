import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://kbnfblujmhxfbanqlqpg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtibmZibHVqbWh4ZmJhbnFscXBnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI2Mjk5MTEsImV4cCI6MjA1ODIwNTkxMX0.VO_iqJB7v-zkDTMjWE3PZuszS6aLuOVW5IPPhivVIBA',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(), // Main app widget
    );
  }
}