import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'display_menu_item_tags.dart';
import 'customize_purchasable_entry.dart';

// This widget is the home page of the POS application.
class CustomizeMenuItem extends StatefulWidget {
  bool isBeingEdited;
  bool isPopup;
  final MenuItem menuItem;
  final Function refresh;

  CustomizeMenuItem({
    super.key,
    required this.menuItem,
    required this.refresh,
    isBeingEdited,
    isPopup
  })
  :
  isBeingEdited = isBeingEdited ?? false,
  isPopup = isPopup ?? false
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

                    SizedBox(height: 5),

                    CustomizePurchasableEntry(
                      title: 'Description: ',
                      controller: controllerDescription,
                    ),

                    SizedBox(height: 5),

                    DisplayItemTags(
                        menuItem : widget.menuItem
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
                                MenuItem newItem = MenuItem(controllerItemName.text,
                                  price: double.parse(controllerPrice.text),
                                  description: controllerDescription.text,
                                );
                                replaceItemInMenu(widget.menuItem, newItem);
                                widget.refresh();
                              } catch (e) {
                                // Does nothing.
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
                    )

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
                  removeItemInMenu(widget.menuItem);
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