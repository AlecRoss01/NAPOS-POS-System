import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'customize_menu_item_entry.dart';

// This widget is the home page of the POS application.
class CustomizeMenuItem extends StatefulWidget {
  bool isBeingEdited;
  final MenuItem menuItem;

  CustomizeMenuItem({
    super.key,
    required this.menuItem,
    isBeingEdited,
  })
  : isBeingEdited = isBeingEdited ?? false
  ;

  @override
  State<CustomizeMenuItem> createState() => _CustomizeMenuItem();
}

// Implementation of home page
class _CustomizeMenuItem extends State<CustomizeMenuItem> {
  late TextEditingController controllerItemName;
  late TextEditingController controllerPrice;
  late TextEditingController controllerDescription;

  @override
  void initState() {
    super.initState();
    // May have to put controller initializations in here.
  }

  @override
  Widget build(BuildContext context) {
    // Controller initializations.
    controllerItemName = TextEditingController(text: widget.menuItem.name);
    controllerPrice = TextEditingController(text: widget.menuItem.price.toString());
    controllerDescription = TextEditingController(text: widget.menuItem.description);

    if(!widget.isBeingEdited) {
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
                    'Item Name: ${widget.menuItem.name}',
                    textAlign: TextAlign.left,
                    style: CustomTextStyle.kitchenEndpointText,
                  ),
                  Text(
                    'Price: ${widget.menuItem.strPrice()}',
                    textAlign: TextAlign.left,
                    style: CustomTextStyle.kitchenEndpointText,
                  ),
                  Text(
                    'Description: ${widget.menuItem.description}',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomizeMenuItemEntry(
                title: 'Item Name: ',
                controller: controllerItemName,
              ),

              SizedBox(height: 5),

              CustomizeMenuItemEntry(
                title: 'Price (\$): ',
                controller: controllerPrice,
              ),

              SizedBox(height: 5),

              CustomizeMenuItemEntry(
                title: 'Description: ',
                controller: controllerDescription,
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
                        //TODO: Set changes
                        widget.isBeingEdited = false;

                        try {
                          MenuItem newItem = MenuItem(controllerItemName.text,
                            price: double.parse(controllerPrice.text),
                            description: controllerDescription.text,
                          );
                          replaceItemInMenu(widget.menuItem, newItem);
                        } catch (e) {
                          // Does nothing.
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
                      });
                    },
                  ),
                ],
              )

            ],
          ),
        )
      );
    }
  }

}