import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/item_addition.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'customize_menu_item_entry.dart';

// This widget is the home page of the POS application.
class CustomizeAddition extends StatefulWidget {
  bool isBeingEdited;
  bool isPopup;
  final ItemAddition addition;

  CustomizeAddition({
    super.key,
    required this.addition,
    isBeingEdited,
    isPopup,
  })
  :
  isBeingEdited = isBeingEdited ?? false,
  isPopup = isPopup ?? false
  ;

  @override
  State<CustomizeAddition> createState() => _CustomizeAddition();
}

// Implementation of home page
class _CustomizeAddition extends State<CustomizeAddition> {
  late TextEditingController controllerItemName;
  late TextEditingController controllerPrice;
  //late TextEditingController controllerDescription;

  @override
  void initState() {
    super.initState();
    // May have to put controller initializations in here.
  }

  @override
  Widget build(BuildContext context) {
    // Controller initializations.
    controllerItemName = TextEditingController(text: widget.addition.name);
    controllerPrice = TextEditingController(text: widget.addition.getprice().toString());
    //controllerDescription = TextEditingController(text: widget.addition.description);

    if(!widget.isBeingEdited && !widget.isPopup) {
      return GestureDetector(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Name: ${widget.addition.name}',
                      textAlign: TextAlign.left,
                      style: CustomTextStyle.kitchenEndpointText,
                    ),
                    Text(
                      'Price: ${widget.addition.strPrice()}',
                      textAlign: TextAlign.left,
                      style: CustomTextStyle.kitchenEndpointText,
                    ),

                  ],
                ),
              )
          ),
        ),
        onTap: () {
          setState(() {
            widget.isBeingEdited = true;
          });
        },
      );
    } else {
      return Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomizePurchasableEntry(
                        title: 'Item Name: ',
                        controller: controllerItemName,
                      ),

                      SizedBox(height: 5),

                      CustomizePurchasableEntry(
                        title: 'Price (\$): ',
                        controller: controllerPrice,
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Done'),
                            ),
                            onPressed: () {
                              setState(() {
                                widget.isBeingEdited = false;

                                try {
                                  if (controllerItemName.text == "" || controllerPrice.text == "") {
                                    throw Exception("Missing a value.");
                                  }
                                  ItemAddition newAddition = ItemAddition(controllerItemName.text, 0, double.parse(controllerPrice.text));
                                  replaceAdditionInMenu(widget.addition, newAddition);
                                } catch (e) {
                                  // Does nothing on a failed parse.
                                }

                                // If it's a popup, closes the popup.
                                if (widget.isPopup) {
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),

                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Cancel'),
                            ),
                            onPressed: () {
                              setState(() {
                                widget.isBeingEdited = false;

                                // If it's a popup, closes the popup.
                                if (widget.isPopup) {
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),

                        ],
                      ),

                    ],
                  ),
                ),

                SizedBox(width: 10),

                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (widget.isPopup) {
                      Navigator.of(context).pop();
                      return;
                    }
                    removeAdditionInMenu(widget.addition);
                  },
                ),

                SizedBox(width: 7),

              ],
            )
          )
      );
    }
  }

}