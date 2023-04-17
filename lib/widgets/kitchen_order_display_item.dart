import 'package:flutter/material.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/classes/order.dart';
import 'package:napos/back_end/client.dart';

import '../styles/styles.dart';

class OrderDisplayItem extends StatefulWidget {
  MenuItem menuItem;

  OrderDisplayItem({
    super.key,
    required this.menuItem,
  });

  @override
  State<OrderDisplayItem> createState() => _OrderDisplayItem();
}

// Implementation of home page
class _OrderDisplayItem extends State<OrderDisplayItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.menuItem.toString(),
          style: CustomTextStyle.kitchenEndpointText,
        ),

        Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.menuItem.additions.length, (index) {
            return Row(
              children: [
                SizedBox(width: 10),
                Text(widget.menuItem.additions[index].name)
              ],
            );
          }),
        )
      ],
    );
  }

}