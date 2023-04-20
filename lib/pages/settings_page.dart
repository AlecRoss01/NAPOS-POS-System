import 'package:flutter/material.dart';
import 'package:napos/pages/order_details.dart';
import '../classes/order.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';

class SettingsPage extends StatefulWidget {
  final String ip;

  const SettingsPage({
    super.key,
    required this.ip
  });

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.ip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              width: 300,
              child: Row(
                children: [
                  Text(
                    "Server IP: ",
                    style: CustomTextStyle.kitchenEndpointText,
                  ),
                  Expanded(
                    child: TextField(
                      style: CustomTextStyle.kitchenEndpointText,
                      controller: controller,
                      //textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2)),
                      ),

                    ),
                  )
                ],
              )
            ),

            SizedBox(height: 10),

            TextButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Save'),
              ),
              onPressed: () {
                setState(() {
                  setNewIP(controller.text);
                });
              },
            ),

          ],
        ),
      )
    );
  }
}