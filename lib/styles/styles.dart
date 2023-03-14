import 'package:flutter/material.dart';

/*
Making custom text styles: https://stackoverflow.com/questions/72053709/create-custom-textstyle-class-on-flutter
Text color: https://flutterdesk.com/how-to-change-text-color-in-flutter-app/
 */

class CustomTextStyle {
  static const TextStyle homeButtons = TextStyle(
    fontSize: 24,
    color: Colors.black54,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: 24,
    color: Colors.black87,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );

  static const TextStyle kitchenEndpointToggles = TextStyle(
    fontSize: 20,
    color: Colors.black54,
  );

  /*
  static const TextStyle commandHubCommands = TextStyle(
    fontSize: 10,
    color: Colors.white,
    backgroundColor: Colors.red,
  );
  */

  static ButtonStyle commandHubCommands = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.red,
  );

  static ButtonStyle editItemButton = TextButton.styleFrom(
    foregroundColor: Colors.red,
    backgroundColor: Colors.white,
  );

  static ButtonStyle saveButton = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green,
  );
}