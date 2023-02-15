import 'package:flutter/material.dart';
import '../classes/order.dart';
import '../styles/styles.dart';
import '../widgets/order_details_widgets.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPage();
}

class _OrderDetailsPage extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Width of app.
    double contextWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order ${widget.order.strOrderID()}"),
      ),
      body: Padding(
        // Takes left half of app space.
        padding: EdgeInsets.fromLTRB(20.0, 20.0, contextWidth/2 + 20.0, 20.0),
        child: Column(
          children: [

            // Order ID
            DetailRow(
              title: "Order ID: ",
              value: widget.order.strOrderID(),
              style: CustomTextStyle.headerText,
            ),

            // Employee who took order.
            DetailRow(
              title: "Taken by: ",
              value: "{Employee name}",
            ),

            // Date order was placed.
            DetailRow(
              title: "Placed on: ",
              value: "{Datetime placed}",
            ),
            Divider(),

            // Order items.
            ListView(
              shrinkWrap: true,
              children: List.generate(widget.order.getOrderItems().length, (index) {
                return DetailRow(
                  title: widget.order.getOrderItems()[index].toString(),
                  value: widget.order.getOrderItems()[index].strSubTotal(),
                );
              })
            ),
            Divider(),

            // Subtotal.
            DetailRow(
              title: "Subtotal: ",
              value: widget.order.strSubTotal()
            ),

            DetailRow(
              title: "Total: ",
              value: "{Total}",
            ),

            DetailRow(
              title: "Tendered: ",
              value: "{Amount tendered}",
            ),

            DetailRow(
              title: "Change: ",
              value: "{Change}",
            ),

          ],
        )
      ),
    );
  }
}