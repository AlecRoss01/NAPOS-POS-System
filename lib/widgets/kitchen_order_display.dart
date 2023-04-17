import 'package:flutter/material.dart';
import 'package:napos/classes/order.dart';
import 'package:napos/back_end/client.dart';

import '../styles/styles.dart';
import 'kitchen_order_display_item.dart';

class OrderDisplayWidget extends StatefulWidget {
  Order order;

  OrderDisplayWidget({
    super.key,
    required this.order,
  });

  @override
  State<OrderDisplayWidget> createState() => _OrderDisplayWidget();
}

// Implementation of home page
class _OrderDisplayWidget extends State<OrderDisplayWidget> {
  List<bool> _done = [false];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${widget.order.strOrderID()}',
                      textAlign: TextAlign.left,
                      style: CustomTextStyle.kitchenEndpointText,
                    ),
                    Text(
                      'Placed At: ${widget.order.dateTimeStr}',
                      textAlign: TextAlign.left,
                      style: CustomTextStyle.kitchenEndpointText,
                    ),
                  ],
                ),
                Spacer(),
                ToggleButtons(
                  children: [
                    Text('Done')
                  ],
                  isSelected: _done,
                  onPressed: (int index) {
                    setState(() {
                      _done[0] = !_done[0];
                      markOrderAsComplete(widget.order, _done[0]);
                    });
                  },
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                SizedBox( width: 20),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.order.orderItems.length,
                    itemBuilder: (context, index) {
                      return OrderDisplayItem(
                        menuItem: widget.order.orderItems[index]
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

}