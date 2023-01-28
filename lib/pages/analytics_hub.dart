import 'package:flutter/material.dart';
import '../classes/order.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';

// Card widget: https://www.geeksforgeeks.org/flutter-card-widget/
// Using InkWell for onTap: https://stackoverflow.com/questions/44317188/flutter-ontap-method-for-containers
// ListView Class: https://api.flutter.dev/flutter/widgets/ListView-class.html
// Dynamic List (For future): https://stackoverflow.com/questions/47826776/how-to-build-a-dynamic-list-in-flutter

class AnalyticsHub extends StatefulWidget {
  const AnalyticsHub({super.key});

  @override
  State<AnalyticsHub> createState() => _AnalyticsHub();
}

class _AnalyticsHub extends State<AnalyticsHub> {

  @override
  Widget build(BuildContext context) {
    // Dimensions of app
    double contextWidth = MediaQuery.of(context).size.width;
    double contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Hub')
      ),
      body: Row(
        children: <Widget>[

          // Container for the Historical Orders list.
          SizedBox(
            width: contextWidth/2,
            child: Column(
              children: [
                // Header for the order list.
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topLeft,
                  child: const Text("Historical Orders", style: CustomTextStyle.homeButtons),
                ),

                // Order List
                Expanded(
                  // Future Builder makes it empty initially. Then when recvOrders returns, it builds.
                  child: FutureBuilder<List<Order>>(
                    future: recvOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return

                          ListView(
                              children: List.generate(snapshot.data!.length, (index) {
                                return InkWell(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ID: ${snapshot.data![index]}'),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // Absolutely hideous, I know. Makes a list of each item in the order (displayed beneath order ID).
                                            children: List.generate(snapshot.data![index].getMenuItems().length, (indexOfOrder) {
                                              return Text(snapshot.data![index].getMenuItems()[indexOfOrder].toString());
                                            })
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                );
                              })
                          );
                        
                      }
                      else {
                        return ListView();
                      }
                    }
                  )
                )
              ],
            )
          ),

          // Container for the Inventory list
          SizedBox(
              width: contextWidth/2,
              child: Column(
                children: [
                  // Header for the inventory list.
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.topLeft,
                    child: const Text("Inventory", style: CustomTextStyle.homeButtons),
                  ),

                  // Inventory list
                  Expanded(
                      child: ListView(
                        children: [
                          Card(child: ListTile(title: Text("Inventory Item"))),
                        ],
                      )
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}