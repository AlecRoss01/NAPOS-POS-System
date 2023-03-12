import 'package:flutter/material.dart';
import 'package:napos/widgets/home_page_button.dart';
import '../styles/styles.dart';
import 'command_hub.dart';
import 'analytics_hub.dart';
import 'kitchen_endpoint.dart';

// This widget is the home page of the POS application.
class POSHomePage extends StatefulWidget {
  const POSHomePage({super.key, required this.title});

  // Fields in a Widget subclass are always marked "final".
  final String title;

  @override
  State<POSHomePage> createState() => _POSHomePage();
}

// Implementation of home page
class _POSHomePage extends State<POSHomePage> {

  // This method is rerun every time setState is called.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Align buttons to center of the row
            children: [
              // First Button, for POS page
              HomePageButton(
                text: 'Point of Sale',
                targetPage: () => CommandHub(),
              ),

              SizedBox(width: 50),

              // Second button, for Analytics Hub page.
              HomePageButton(
                text: 'Analytics Hub',
                targetPage: () => AnalyticsHub(),
              ),

            ],
          ),

          SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomePageButton(
                text: 'Kitchen Endpoint',
                targetPage: () => KitchenEndpointPage(),
              ),
            ],
          ),

          Spacer()
        ],
      )
    );
  }
}