import 'package:flutter/material.dart';
import 'package:napos/pages/login_page.dart';
import 'styles/styles.dart';
import 'pages/command_hub.dart';
import 'pages/analytics_hub.dart';
import 'pages/pos_home_page.dart';
import 'back_end/client.dart';

// Runs the app.
void main() {
  runApp(const NaposPOS());
}

// Definition of the application
class NaposPOS extends StatelessWidget {
  const NaposPOS({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Napos POS',
      debugShowCheckedModeBanner: false,

      //Theme for application
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginScreen(),
    );
  }
}


