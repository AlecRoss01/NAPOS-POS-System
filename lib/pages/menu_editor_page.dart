import 'package:flutter/material.dart';
import 'package:napos/back_end/client.dart';
import 'package:napos/classes/item_addition.dart';
import 'package:napos/classes/menu_item.dart';
import 'package:napos/styles/styles.dart';
import 'package:napos/widgets/customize_addition.dart';
import '../widgets/customize_menu_item.dart';

// This widget is the home page of the POS application.
class MenuEditor extends StatefulWidget {
  const MenuEditor({
    super.key,
  });

  @override
  State<MenuEditor> createState() => _MenuEditor();
}

// Implementation of home page
class _MenuEditor extends State<MenuEditor> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Editor"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          'Menu: ',
                          textAlign: TextAlign.left,
                          style: CustomTextStyle.headerText,
                        ),

                        Spacer(),

                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Create new menu item:"),
                                  content: Container(
                                    width: 500,
                                    height: 500,
                                    child: CustomizeMenuItem(
                                      menuItem: MenuItem("New Menu Item"),
                                      isPopup: true,
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                        )
                      ],
                    )
                ),
              ),

              SizedBox(width: 20),

              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          'Additions: ',
                          textAlign: TextAlign.left,
                          style: CustomTextStyle.headerText,
                        ),

                        Spacer(),

                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Create new addition:"),
                                    content: Container(
                                      width: 500,
                                      height: 500,
                                      child: CustomizeAddition(
                                        addition: ItemAddition("New Addition", 0, 0),
                                        isPopup: true,
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                        )
                      ],
                    )
                ),
              ),

            ],
          ),


          Expanded(
            child: Row(
              children: [
                // Menu items.
                Expanded(
                  child: FutureBuilder<List<MenuItem>>(
                    future: recvMenu(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return CustomizeMenuItem(
                                menuItem: snapshot.data![index]
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container();
                          },
                        );
                      } else {
                        return Text('No Data');
                      }
                    },
                  ),
                ),

                SizedBox(width: 20),

                // Item additions.
                Expanded(
                  child: FutureBuilder<List<ItemAddition>>(
                    future: recvItemAdditions(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return CustomizeAddition(
                                addition: snapshot.data![index]
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container();
                          },
                        );
                      } else {
                        return Text('No Data');
                      }
                    },
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

}