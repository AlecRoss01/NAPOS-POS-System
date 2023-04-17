import 'package:flutter/material.dart';
import 'package:napos/widgets/CH_AdditionType_Buttons.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import '../classes/item_addition.dart';
import '../widgets/CH_AdditionType_Buttons.dart';

class EditItemSidebar extends StatefulWidget {
    final menu_item.MenuItem editItem;
    final Function(menu_item.MenuItem) removeItemFromOrder;
    final Function() updateAdditions;

    const EditItemSidebar({
      super.key,
      required this.editItem,
      required this.removeItemFromOrder,
      required this.updateAdditions
    });

    @override
    State<EditItemSidebar> createState() => _EditItemSidebarState();
}

class _EditItemSidebarState extends State<EditItemSidebar> {
    var additionType = AdditionType.none;
    List<ItemAddition> listOfAdditions = [];
    final ScrollController _scrollController = ScrollController();
    bool _needsScroll = false;

    _scrollToEnd() async {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut
      );
    }

    void setAdditionType(AdditionType type){
      setState(() {
        additionType = type;
      });
    }

    @override
    Widget build(BuildContext context) {
        if (_needsScroll){
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToEnd());
          _needsScroll = false;
        }
        listOfAdditions = widget.editItem.additions;
        return Drawer(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      SizedBox(height: 30),
                        Text(
                            widget.editItem.toString(),
                            style: TextStyle(fontSize: 24)
                        ),
                        SizedBox(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: listOfAdditions.length,
                              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 50.0, right: 50.0),
                              itemBuilder: (context, index) =>
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.black12,),
                                      child: Text(listOfAdditions[index].typeAndNameString()),
                                      onPressed: () => setState(() {
                                        listOfAdditions.remove(listOfAdditions[index]);
                                        })
                                    ),
                                  )
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
                              AdditionTypeToggleButtons(setAdditionType: setAdditionType)
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
                                                                        setState(() {
                                                                          if (additionType == AdditionType.none){
                                                                            additionType = AdditionType.add;
                                                                          }
                                                                          snapshot.data![index].setAdditionType(additionType);
                                                                          listOfAdditions.add(snapshot.data![index]);
                                                                          _needsScroll = true;
                                                                        });
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
                                      widget.editItem.additions = listOfAdditions;
                                      widget.updateAdditions();
                                      Navigator.of(context).pop();
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