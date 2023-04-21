import 'package:flutter/material.dart';
import 'package:napos/pages/pos_home_page.dart';
import 'package:napos/pages/settings_page.dart';
import 'package:napos/styles/styles.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/widgets/pin_number_button.dart';
import 'package:napos/widgets/delete_number_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var pin = <int>[];
  String errorMessage = "";

  void addNumToPIN(String number) {
    setState(() {
      if (pin.length == 4) {
        return;
      } else {
        pin.add(int.parse(number));
        errorMessage = "";
      }
    });
  }

  void delLastPINNumber() {
    setState(() {
      if (!pin.isEmpty) {
        pin.removeLast();
      }
    });
  }

  String pinToString() {
    String returnString = "";
    if (pin.isEmpty) {
      return returnString;
    }
    for (int i = 0; i < pin.length; i++) {
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
            children: <Widget>[
              Text(errorMessage),
              Container(
                child: SizedBox(
                  width: 160, child: Center(child: Text(pinToString()))),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  border: Border.all(width: 2)),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PinNumberButton(number: "1", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "2", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "3", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PinNumberButton(number: "4", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "5", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "6", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PinNumberButton(number: "7", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "8", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  PinNumberButton(number: "9", addNumberToPIN: addNumToPIN)
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PinNumberButton(number: "0", addNumberToPIN: addNumToPIN),
                  SizedBox(width: 10),
                  DeleteNumberButton(delSymbol: "DEL", removeLastNum: delLastPINNumber),
                  SizedBox(width: 10),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
                      child: Icon(Icons.settings),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage(ip: connString))
                      );
                    },
                  )
                ]
              ),
              SizedBox(height: 10),
              TextButton(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Login", style: CustomTextStyle.homeButtons)
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)
                    )
                  )
                ),
                onPressed: () async {
                  //check login credentials here, if they pass got to POS Home Page
                  if (await checkPINNumbers(int.parse(pinToString()))) {
                    var employee = await getEmployeeFromPin(int.parse(pinToString()));
                    setState(() {
                      pin.clear();
                      errorMessage = "";
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return POSHomePage(
                            employee: employee,
                            title: 'Napos POS'
                          );
                        }
                      )
                    );
                  } else {
                    setState(() {
                      errorMessage = "Invalid Pin";
                      pin.clear();
                    });
                  }
                }
              )
            ]
          )
        )
      )
    );
  }
}