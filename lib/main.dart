import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/data_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataService(),
      child: const MandarinStudyApp(),
    ),
  );
}

class MandarinStudyApp extends StatelessWidget {
  const MandarinStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MandarinStudy HSK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1565C0),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}
