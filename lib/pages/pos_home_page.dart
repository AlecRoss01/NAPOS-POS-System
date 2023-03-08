import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'command_hub.dart';
import 'analytics_hub.dart';

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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Align buttons to center of the row
          children: <Widget>[
            // Sized boxes wrap buttons so they can be sized
            // First Button, for POS page
            SizedBox(
              height: 100,
              width: 200,
              child: TextButton(
                child: const Text("Point of Sale", style:CustomTextStyle.homeButtons),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CommandHub())
                  );
                },
              ),
            ),
            // Space between buttons
            SizedBox(width: 50,),
            // Second Button, for Analytics Hub page
            SizedBox(
              height: 100,
              width: 200,
              child: TextButton(
                child: const Text("Analytics Hub", style:CustomTextStyle.homeButtons),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AnalyticsHub())
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}