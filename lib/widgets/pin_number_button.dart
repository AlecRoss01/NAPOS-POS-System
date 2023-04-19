import 'package:flutter/material.dart';

import 'package:napos/styles/styles.dart';

class PinNumberButton extends StatefulWidget {
  final String number;
  final Function(String) addNumberToPIN;

  const PinNumberButton({
    super.key,
    required this.number,
    required this.addNumberToPIN
  });

  State<PinNumberButton> createState() => _PinNumberButtonState();
}

class _PinNumberButtonState extends State<PinNumberButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        widget.number,
        style: CustomTextStyle.homeButtons
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
        widget.addNumberToPIN(widget.number);
      }
    );
  }
}