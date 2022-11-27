import 'package:flutter/material.dart';
import 'styles.dart';
import 'hardcoded_pos_data.dart';
import 'client.dart';

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
  //final histOrders = buildHistOrders();
  final histOrders = recvOrders();

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
                  child: ListView(
                    children: List.generate(histOrders.length, (index) {
                      return InkWell(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${histOrders[index]}'),
                                Text(histOrders[index].orderItem()),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {},
                      );
                    })
                  ),
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