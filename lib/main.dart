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
  
  var pin = <int>[];

  void addNumToPIN(String number){
    setState(() {
      if (pin.length == 4){
        return;
      }
      else {
        pin.add(int.parse(number));
      }
    });
  }

  void delLastPINNumber() {
    setState(() {
      if (!pin.isEmpty)
      {
        pin.removeLast();
      }
    });
  }

  String pinToString() {
    String returnString = "";
    if (pin.isEmpty){
      return returnString;
    }
    for (int i = 0; i < pin.length; i++)
    {
      returnString += pin[i].toString();
    }
    return returnString;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(pinToString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "1", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "2", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "3", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "4", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "5", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "6", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "7", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "8", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumber(number: "9", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  PinNumber(number: "0", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  DelNumber(delSymbol: "DEL", removeLastNum: delLastPINNumber),
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
                  setState(() {
                    pin.clear();
                  });
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

class PinNumber extends StatefulWidget {
  final String number;
  final Function(String) addNumberToPIN;
  const PinNumber({super.key, required this.number, required this.addNumberToPIN});

  State<PinNumber> createState() => _PinNumberState();
}

class _PinNumberState extends State<PinNumber> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.number, style:CustomTextStyle.homeButtons),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)
          )
        )
      ),
      onPressed: () {
        widget.addNumberToPIN(widget.number);
      }
    );
  }
}

class DelNumber extends StatefulWidget {
  final String delSymbol;
  final Function() removeLastNum;
  const DelNumber({super.key, required this.delSymbol, required this.removeLastNum});

  State<DelNumber> createState() => _DelNumberState();
}

class _DelNumberState extends State<DelNumber> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.delSymbol, style:CustomTextStyle.homeButtons),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)
          )
        )
      ),
      onPressed: () {
        widget.removeLastNum();
      }
    );
  }
}