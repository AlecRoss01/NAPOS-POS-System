import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';

class EditItemSidebar extends StatefulWidget {
    final menu_item.MenuItem editItem;
    final Function(menu_item.MenuItem) removeItemFromOrder;
    const EditItemSidebar({super.key, required this.editItem, required this.removeItemFromOrder});

    @override
    State<EditItemSidebar> createState() => _EditItemSidebarState();
}

class _EditItemSidebarState extends State<EditItemSidebar> {
    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                        Text(
                            widget.editItem.toString(),
                            style: TextStyle(fontSize: 24)
                        ),
                        SizedBox(height: 200), //Could insert picture of the item here
                        TextButton(
                            style: CustomTextStyle.commandHubCommands,
                            child: const Text("Remove Item From Order"),
                            onPressed: () {
                                widget.removeItemFromOrder(widget.editItem);
                                Navigator.of(context).pop();
                            },
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget> [
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Remove"),
                                    onPressed: () {},
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Add"),
                                    onPressed: () {},
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Light"),
                                    onPressed: () {},
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Extra"),
                                    onPressed: () {},
                                )
                            ]
                        ),
                        SizedBox(height: 300), //Have grid view of all possible additions/removals for the given item, read from database
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                                TextButton(
                                    style: CustomTextStyle.saveButton,
                                    child: const Text("Save"),
                                    onPressed: () {},
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                    style: CustomTextStyle.commandHubCommands,
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                        Navigator.of(context).pop();
                                    }
                                )
                            ]
                        ),
                        SizedBox(height: 20)
                    ]
                )
            )
        );
    } 
}