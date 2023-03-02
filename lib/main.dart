import 'package:flutter/material.dart';
import 'styles/styles.dart';
import 'pages/command_hub.dart';
import 'pages/analytics_hub.dart';
import 'pages/pos_home_page.dart';

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
      //Theme for application
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "1"),
                  SizedBox(width: 10),
                  PinNumber(number: "2"),
                  SizedBox(width: 10),
                  PinNumber(number: "3")
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "4"),
                  SizedBox(width: 10),
                  PinNumber(number: "5"),
                  SizedBox(width: 10),
                  PinNumber(number: "6")
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "7"),
                  SizedBox(width: 10),
                  PinNumber(number: "8"),
                  SizedBox(width: 10),
                  PinNumber(number: "9")
                ]
              ),
              SizedBox(height: 10),
              TextButton(
                child: Padding(
                  padding: EdgeInsets.all(15), 
                  child: Text("Login", style:CustomTextStyle.homeButtons)
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)
                    )
                  )
                ),
                onPressed: () {
                  //check login credentials here, if they pass got to POS Home Page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const POSHomePage(title: 'Napos POS')));
                }
              )
            ]
          )
        )
      )
    );
  }
}

class PinNumber extends StatelessWidget {
  final String number;
  const PinNumber({super.key, required this.number});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(number, style:CustomTextStyle.homeButtons),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)
          )
        )
      ),
      onPressed: () {
      }
    );
  }
}