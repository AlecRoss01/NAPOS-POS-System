import 'package:flutter/material.dart';
import 'styles.dart';

// Runs the app.
void main() {
  runApp(const NaposPOS());
}

// Definition of the application
class NaposPOS extends StatelessWidget {
  const NaposPOS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Napos POS',
      //Theme for application
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const POSHomePage(title: 'Napos POS'),
    );
  }
}

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
        title: Text(widget.title),
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
            const SizedBox(width: 50,),
            // Second Button, for Analytics Hub page
            const SizedBox(
              height: 100,
              width: 200,
              child: TextButton(
                onPressed: null, // Disabled for now
                child: Text("Analytics Hub", style:CustomTextStyle.homeButtons),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class CommandHub extends StatelessWidget {
  const CommandHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Command Hub'),
      ),
      body: Row(
        children: <Widget>[
          //1st section, section that holds buttons for each of the categories on the menu
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 10
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Text("Food")
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Drinks")
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Merch")
                  )
                ]
              )
            )
          ),
          //2nd section, section that holds item buttons according to whichever button was pressed in 1st section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 10
                  )
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 1")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 2")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 3")
                        )
                      ]
                    )
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 4")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 5")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 6")
                        )
                      ]
                    )
                  ) 
                ]
              )
            )
          ),
          //3rd section, section that contains order information and buttons that apply to order
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 10
                      )
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text("Order info goes here.")
                            ]
                          )
                        )
                      ]
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 10
                      )
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: Text("Send")
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("Pay")
                              )
                            ]
                          )
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: Text("Print Receipt")
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("Edit")
                              )
                            ]
                          )
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        ]
      ),
    );
  }
}