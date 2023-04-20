import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/employee.dart';
import 'package:napos/pages/settings_page.dart';
import 'package:napos/widgets/home_page_button.dart';
import 'command_hub.dart';
import 'analytics_hub.dart';
import 'kitchen_endpoint.dart';
import 'menu_editor_page.dart';

// This widget is the home page of the POS application.
class POSHomePage extends StatefulWidget {
  const POSHomePage({
    super.key,
    required this.title,
    required this.employee,
  });

  // Fields in a Widget subclass are always marked "final".
  final String title;
  final NAPOS_Employee employee;

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
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(ip: connString))
              );
            }, 
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 10),
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
                targetPage: () => CommandHub(employee : widget.employee),
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

              SizedBox(width: 50),

              HomePageButton(
                text: 'Menu Editor',
                targetPage: () => MenuEditor(),
              ),
            ],
          ),

          Spacer()
        ],
      )
    );
  }
}