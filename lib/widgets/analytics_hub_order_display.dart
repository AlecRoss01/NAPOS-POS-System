import 'package:flutter/material.dart';

import 'package:napos/classes/order.dart';
import 'package:napos/pages/order_details.dart';

class AnalyticsHubOrderDisplay extends StatefulWidget {
  final Order order;

  const AnalyticsHubOrderDisplay({
    super.key,
    required this.order
  });

  @override
  State<AnalyticsHubOrderDisplay> createState() => _AnalyticsHubOrderDisplay();
}

class _AnalyticsHubOrderDisplay extends State<AnalyticsHubOrderDisplay> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order info.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${widget.order}'),
                  Text('Taken by: ${widget.order.orderTaker.name}'),
                  Text('Placed on: ${widget.order.dateTimeStr}'),
                  Text('Subtotal: ${widget.order.strSubTotal()}'),
                ],
              ),

              Spacer(),

              // Order items.
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(widget.order.getOrderItems().length, (indexOfOrder) {
                    return Text(widget.order.getOrderItems()[indexOfOrder].toString());
                  })
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderDetailsPage(order: widget.order))
        );
      },
    );
  }
}