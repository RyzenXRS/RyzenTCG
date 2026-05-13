import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const RyzentcgApp());
}

class RyzentcgApp extends StatelessWidget {
  const RyzentcgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ryzen TCG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
