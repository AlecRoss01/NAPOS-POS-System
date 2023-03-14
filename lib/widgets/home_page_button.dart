import 'package:flutter/material.dart';

// Styles
import 'package:napos/styles/styles.dart';

class HomePageButton extends StatefulWidget {
  final String text;
  final TextStyle _style;
  final Function() targetPage;

  HomePageButton({
    super.key,
    required this.text,
    required this.targetPage,
    TextStyle? style,
  })
      : _style = style ?? CustomTextStyle.homeButtons;

  @override
  State<HomePageButton> createState() => _HomePageButton();
}

class _HomePageButton extends State<HomePageButton> {
  @override
  Widget build(BuildContext context) {
    // Sized boxes wrap buttons so they can be sized
    return SizedBox(
      height: 100,
      width: 200,
      child: TextButton(
        child: Text(widget.text, style:widget._style, textAlign: TextAlign.center,),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.targetPage())
          );
        },
      ),
    );
  }
}