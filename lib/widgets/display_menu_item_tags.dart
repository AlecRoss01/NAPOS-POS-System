import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'add_tag_popup.dart';

class DisplayItemTags extends StatefulWidget {

  final MenuItem menuItem;

  DisplayItemTags({
    super.key,
    required this.menuItem,
  });

  @override
  State<DisplayItemTags> createState() => _DisplayItemTags();
}

class _DisplayItemTags extends State<DisplayItemTags> {

  void addTagToMyItem(String tag) {
    setState(() {
      widget.menuItem.addCatTag(tag);
      updateCatTags(widget.menuItem);
    });
  }

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
                                  setState(() {
                                    widget.menuItem.removeCatTag(widget.menuItem.categories.elementAt(index));
                                  });
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Create new menu item:"),
                                content: Container(
                                  width: 500,
                                  height: 200,
                                  child: AddTagPopup(
                                    menuItem: widget.menuItem,
                                    addTagToMyItem: addTagToMyItem,
                                  ),
                                ),
                              );
                            }
                          );
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