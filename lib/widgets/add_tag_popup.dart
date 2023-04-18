import 'package:flutter/material.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';

// This widget is the home page of the POS application.
class AddTagPopup extends StatefulWidget {

  final MenuItem menuItem;
  final Function(String) addTagToMyItem;

  AddTagPopup({
    super.key,
    required this.menuItem,
    required this.addTagToMyItem,
  });

  @override
  State<AddTagPopup> createState() => _AddTagPopup();
}

// Implementation of home page
class _AddTagPopup extends State<AddTagPopup> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerTagName = TextEditingController(text: widget.menuItem.name);

    return Container(
      width: 500,
      height: 500,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Enter tag: ',
                style: CustomTextStyle.kitchenEndpointText,
              ),
              Expanded(
                child:TextField(
                  controller: controllerTagName,
                  style: CustomTextStyle.kitchenEndpointText,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)),
                      hintText: "Tag..."
                  ),

                ),
              )
            ],
          ),


          Row(
            children: [
              TextButton(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Done'),
                ),
                onPressed: () {
                  setState(() {
                    widget.addTagToMyItem(controllerTagName.text);
                    //widget.menuItem.addCatTag(controllerTagName.text);
                    //updateCatTags(widget.menuItem);
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          )

        ],
      ),
    );
  }

}