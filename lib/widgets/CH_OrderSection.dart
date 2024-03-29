import 'package:flutter/material.dart';
import 'package:napos/classes/employee.dart';
import 'package:napos/widgets/item_in_current_order_display.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';

class OrderSection extends StatefulWidget {
  final Order currentOrder;
  final Function(menu_item.MenuItem) setEditItem;
  final Function(Order) payButtonClick;
  final double width;
  final NAPOS_Employee employee;

  const OrderSection({
    super.key,
    required this.currentOrder,
    required this.setEditItem,
    required this.payButtonClick,
    required this.width,
    required this.employee,
  });

  @override
  State<OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(children: [
        // Header for the MenuItems grid.
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.topLeft,
          child:
              const Text("Current Order", style: CustomTextStyle.homeButtons),
        ),
        // Current order details.
        Expanded(
          //height: 300,
          child: ListView(
            children: List.generate(widget.currentOrder.getOrderLength(), (index) {
                return InkWell(
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ItemInCurrentOrderDisplay(
                          menuItem: widget.currentOrder.getItemAtIndex(index),
                          width: widget.width,
                        )),
                  ),
                  onTap: () {
                    widget.setEditItem(widget.currentOrder.getItemAtIndex(index));
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
            )
          )
        ),

        const SizedBox(height: 10),

        // Order command buttons.
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Send"),
                  onPressed: () {
                    setState(() {
                      if (widget.currentOrder.getOrderItems().isNotEmpty) {
                        Order myOrder = Order(widget.employee);
                        myOrder
                            .addItemsToOrder(widget.currentOrder.getOrderItems());
                        sendOrder(myOrder);
                        widget.currentOrder.getOrderItems().clear();
                      }
                    });
                  },
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: TextButton(
                  style: CustomTextStyle.commandHubCommands,
                  child: const Text("Pay"),
                  onPressed: () {
                    widget.payButtonClick(widget.currentOrder);
                  },
                )
              )
            ],
          ),
        )
      ]),
    );
  }
}
