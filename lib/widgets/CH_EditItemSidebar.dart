import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import '../classes/item_addition.dart'; 

class EditItemSidebar extends StatefulWidget {
    final menu_item.MenuItem editItem;
    final Function(menu_item.MenuItem) removeItemFromOrder;
    final Function(menu_item.MenuItem, List<ItemAddition>) addAdditionsToItem;
    const EditItemSidebar({super.key, required this.editItem, required this.removeItemFromOrder, required this.addAdditionsToItem});

    @override
    State<EditItemSidebar> createState() => _EditItemSidebarState();
}

class _EditItemSidebarState extends State<EditItemSidebar> {
    var additionType = AdditionType.none;
    final listOfAdditions = <ItemAddition>[];
    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                        Text(
                            widget.editItem.toString(),
                            style: TextStyle(fontSize: 24)
                        ),
                        SizedBox(
                            height: 200,
                            /*child: have list view of all current available additions that you can remove when clicked on*/
                        ),
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
                                /*add way to highlight addition type button when clicked so user know what type they are adding*/
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Remove"),
                                    onPressed: () {
                                        additionType = AdditionType.remove;
                                    },
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Add"),
                                    onPressed: () {
                                        additionType = AdditionType.add;
                                    },
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Light"),
                                    onPressed: () {
                                        additionType = AdditionType.light;
                                    },
                                ),
                                OutlinedButton(
                                    style: CustomTextStyle.editItemButton,
                                    child: const Text("Extra"),
                                    onPressed: () {
                                        additionType = AdditionType.extra;
                                    },
                                )
                            ]
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            child:Column(
                                children: <Widget>[
                                    Container(
                                        height: 325,
                                        child: FutureBuilder<List<ItemAddition>>(
                                            future: recvItemAdditions(),
                                            builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                    return GridView(
                                                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                            maxCrossAxisExtent: 150,
                                                            mainAxisExtent: 100,
                                                        ),
                                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                        shrinkWrap: true,
                                                        children: List.generate(snapshot.data!.length, (index){
                                                            return InkWell(
                                                                child: Card(
                                                                        child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                                Text(snapshot.data![index].toString(), textAlign: TextAlign.center),
                                                                                Text(snapshot.data![index].strPrice())
                                                                            ],
                                                                        )
                                                                    ),
                                                                    onTap: () {
                                                                        snapshot.data![index].setAdditionType(additionType);
                                                                        listOfAdditions.add(snapshot.data![index]);
                                                                    },
                                                                );
                                                            
                                                        })
                                                    );
                                                }
                                                else {
                                                    return GridView.count(crossAxisCount: 2);
                                                }
                                            }
                                        )
                                    )
                                    
                                ]
                            )
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                                TextButton(
                                    style: CustomTextStyle.saveButton,
                                    child: const Text("Save"),
                                    onPressed: () {
                                        // call add item additions to item and send list of additions
                                    },
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                    style: CustomTextStyle.commandHubCommands,
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                        // clear list of additions to be added
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