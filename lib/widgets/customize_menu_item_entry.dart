import 'package:flutter/material.dart';
import 'package:napos/classes/menu_item.dart';

import 'package:napos/styles/styles.dart';

// This widget is the home page of the POS application.
class CustomizeMenuItemEntry extends StatefulWidget {
  final TextEditingController controller;
  final String title;

  const CustomizeMenuItemEntry({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  State<CustomizeMenuItemEntry> createState() => _CustomizeMenuItemEntry();
}

// Implementation of home page
class _CustomizeMenuItemEntry extends State<CustomizeMenuItemEntry> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title,
          style: CustomTextStyle.kitchenEndpointText,
        ),
        Expanded(
          child:TextField(
            style: CustomTextStyle.kitchenEndpointText,
            controller: widget.controller,
            //textAlign: TextAlign.left,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2)),
            ),

          ),
        )
      ],
    );
  }

}