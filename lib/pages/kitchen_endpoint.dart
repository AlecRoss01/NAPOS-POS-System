import 'dart:async';

import 'package:flutter/material.dart';
import 'package:napos/classes/order.dart';

import '../back_end/client.dart';
import '../styles/styles.dart';
import '../widgets/kitchen_order_display.dart';

class KitchenEndpointPage extends StatefulWidget {
  bool todo;

  KitchenEndpointPage({
    super.key,
    this.todo = true,
  });

  @override
  State<KitchenEndpointPage> createState() => _KitchenEndpointPage();
}

// Implementation of home page
class _KitchenEndpointPage extends State<KitchenEndpointPage> {
  List<Order> completeOrders = [];
  List<Order> inCompleteOrders = [];
  late Timer myUpdater;

  @override
  void initState() {
    const Duration oneSecond = Duration(seconds: 1);
    const Duration oneMinute = Duration(minutes: 1);
    myUpdater = Timer.periodic(oneSecond, (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    myUpdater.cancel();
  }

  void setToDo(bool todo) {
    setState(() {
      widget.todo = todo;
    });
  }

  void updateOrders() async {
    completeOrders = await recvCompleteOrders();
    inCompleteOrders = await recvIncompleteOrders();
    // Call to rebuild.
    setState(() {});

    //orders = newOrders;
    // Remove all
    /*
      for (int i = 0; i < orders.length; i++) {
        newOrders.removeWhere((element) => element == orders[i]);
      }
    */
  }

  Future<List<Order>> getOrders() async {
    //print(orders);
    if (widget.todo) {
      return completeOrders;
    } else {
      return inCompleteOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    updateOrders();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Kitchen Endpoint'),
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // Toggle between to-do and incomplete.
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      child: Text('To Do', style:CustomTextStyle.kitchenEndpointToggles, textAlign: TextAlign.center,),
                      onPressed: () {
                        setToDo(true);
                      },
                    ),
                  ),
                ),

                Expanded(
                  child:SizedBox(
                    height: 50,
                    child: TextButton(
                      child: Text('Completed', style:CustomTextStyle.kitchenEndpointToggles, textAlign: TextAlign.center,),
                      onPressed: () {
                        setToDo(false);
                      },
                    ),
                  ),
                ),
              ],
            ),

            // List of orders.
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Order>>(
                      //TODO: HERE, WE NEED TO DISTINGUISH BETWEEN TODO, AND FINISHED ORDERS.
                      future: getOrders(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            //shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return OrderDisplayWidget(order: snapshot.data![index]);
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          );
                        }
                        else {
                          return Text('No data');
                        }
                      },
                    )
                  )
                ],
              ),
            )

          ],
        ),
      )
    );
  }

}