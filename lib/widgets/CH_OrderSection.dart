import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import 'CH_EditItemSidebar.dart';

class OrderSection extends StatefulWidget {
  final currentOrder;
  final Function(menu_item.MenuItem) setEditItem;
  const OrderSection({super.key, required this.currentOrder, required this.setEditItem});

  @override
  State<OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          // Header for the MenuItems grid.
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: const Text("Current Order", style: CustomTextStyle.homeButtons),
          ),
          // Current order details.
          Expanded (
            //height: 300,
            child: ListView(
              children: List.generate(widget.currentOrder.getOrderLength(), (index) {
                return InkWell(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.currentOrder.getItemAtIndex(index).toString())
                        ],
                      )
                    ),
                  ),
                  onTap: () {
                    widget.setEditItem(widget.currentOrder.getItemAtIndex(index));
                    Scaffold.of(context).openEndDrawer();
                    
                  },
                );
              })
            )
          ),
          // Spacer between list of order items and command buttons.
          const SizedBox( height: 10,),

          // Command buttons (pay, receipt, etc).
          SizedBox(
            height: 105,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                mainAxisExtent: 50,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              shrinkWrap: true,
              children: [
                TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Send"),
                  onPressed: () {
                    setState(() {
                      // TEMPORARY, ONLY SENDS FIRST ITEM IN ORDER
                      if (widget.currentOrder.getOrderItems().isNotEmpty) {
                        //print(Order(0, order[0].toString()));
                        //print(Order(0, order[0].toString()).orderItem());
                        Order myOrder = Order(1);
                        myOrder.addItemToOrder(widget.currentOrder.getItemAtIndex(0));
                        sendOrder(myOrder);
                        widget.currentOrder.getOrderItems().clear();
                      }
                    });
                  },
                ),
                TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Pay"),
                  onPressed: () {},
                ),
                TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Receipt"),
                  onPressed: () {},
                ),
                TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Edit"),
                  onPressed: () {},
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}