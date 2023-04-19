import 'package:flutter/material.dart';

import 'package:napos/styles/styles.dart';


class DeleteNumberButton extends StatefulWidget {
  final String delSymbol;
  final Function() removeLastNum;

  const DeleteNumberButton({
    super.key,
    required this.delSymbol,
    required this.removeLastNum
  });

  State<DeleteNumberButton> createState() => _DeleteNumberButtonState();
}

class _DeleteNumberButtonState extends State<DeleteNumberButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        widget.delSymbol,
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
        widget.removeLastNum();
      }
    );
  }
}