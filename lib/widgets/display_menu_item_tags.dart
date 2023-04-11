import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'customize_purchasable_entry.dart';

// This widget is the home page of the POS application.
class DisplayItemTags extends StatefulWidget {

  final MenuItem menuItem;

  DisplayItemTags({
    super.key,
    required this.menuItem,
  });

  @override
  State<DisplayItemTags> createState() => _DisplayItemTags();
}

// Implementation of home page
class _DisplayItemTags extends State<DisplayItemTags> {
  @override
  Widget build(BuildContext context) {

    //SizedBox(width: 5),

    return Container(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Body here:
          Row(
            children: [
              Text(
                'Categories: ',
                style: CustomTextStyle.kitchenEndpointText
              ),

              SizedBox(width: 5),

              // Categories:
              Row(
                children: List.generate(widget.menuItem.categories.length, (index) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 2
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(6, 3, 3, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(widget.menuItem.categories.elementAt(index)),
                              InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                onTap: () {
                                  // TODO remove tag from menu item.
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 5),
                    ],
                  );
                })
              ),

              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 2
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.add,
                          size: 20,
                        ),
                        onTap: () {
                          // TODO add new tag.
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

}