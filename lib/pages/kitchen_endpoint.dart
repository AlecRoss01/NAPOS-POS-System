import 'package:flutter/material.dart';
import 'package:napos/classes/order.dart';

import '../back_end/client.dart';
import '../styles/styles.dart';

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
  List<Order> orders = [];

  void setToDo(bool todo) {
    setState(() {
      widget.todo = todo;
    });
  }

  void updateOrders() async {
    setState(() async {
      orders = await recvOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      future: recvOrders(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            //shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Text(
                                //TODO: MAKE WIDGET FOR AN ORDER.
                                'ID: ${snapshot.data![0]}'
                              );
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