import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/category.dart';

class MenuItemSection extends StatefulWidget {
  final Function(menu_item.MenuItem) addItemToOrder;
  final POS_Category categoryToBeDisplayed;
  const MenuItemSection({super.key, required this.addItemToOrder, required this.categoryToBeDisplayed});

  @override
  State<MenuItemSection> createState() => _MenuItemSectionState();
}

class _MenuItemSectionState extends State<MenuItemSection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Header for the MenuItems grid
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: const Text("Items", style: CustomTextStyle.homeButtons),
          ),
          // Being an expanded lets it take up all available space between categories and curr order columns.
          Expanded(
            // Gridview method: https://codesinsider.com/flutter-gridview-example/
            // Gridview.count method: https://www.geeksforgeeks.org/flutter-gridview/
            child: FutureBuilder<List<menu_item.MenuItem>>(
              future: recvMenuCat(widget.categoryToBeDisplayed),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisExtent: 100,
                    ),
                    padding: const EdgeInsets.only(left:10.0, right:10),
                    shrinkWrap: true,
                    // Generates the cards for GridView from 'menu'
                    children: List.generate(snapshot.data!.length, (index) {
                      return InkWell(
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data![index].toString(),
                                textAlign: TextAlign.center,
                              ),
                              Text(snapshot.data![index].strPrice())
                            ],
                          )
                        ),
                        // On click it adds the corresponding menu item to the order.
                        onTap: () {
                          widget.addItemToOrder(snapshot.data![index]);
                        },
                      );
                    })
                  );
                }
                else {
                  return GridView.count(crossAxisCount: 2);
                }
              },
            )
          )
        ],
      ),
    );
  }
}