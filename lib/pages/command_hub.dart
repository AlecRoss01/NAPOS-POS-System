import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import '../widgets/CH_MenuSection.dart';
import '../widgets/CH_CategorySection.dart';
import '../widgets/CH_OrderSection.dart';
import '../widgets/CH_EditItemSidebar.dart';

class CommandHub extends StatefulWidget {
  const CommandHub({super.key});

  @override
  State<CommandHub> createState() => _CommandHub();
}

class _CommandHub extends State<CommandHub> {
  
  final currentOrder = new Order(1);
  POS_Category currentCategory = new POS_Category("Food", 1);
  menu_item.MenuItem itemToEdit = new menu_item.MenuItem("default");
  
  void addToOrder(menu_item.MenuItem item) {
    setState(() {
      currentOrder.addItemToOrder(item);
    });
  }

  void changeCurrentCategory(POS_Category newCat) {
    setState(() { 
      currentCategory = newCat;
    });
  }

  void setItemToEdit(menu_item.MenuItem item) {
    setState(() {
      itemToEdit = item;
    });
  }

  void removeItemFromOrder(menu_item.MenuItem item) {
    setState(() {
      currentOrder.removeItemFromOrder(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions of app
    double contextWidth = MediaQuery.of(context).size.width;
    double contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: EditItemSidebar(editItem: itemToEdit, removeItemFromOrder: removeItemFromOrder),
      appBar: AppBar(
        title: const Text('Command Hub'),
        actions: <Widget>[
          new Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            // 1st section, section that holds buttons for each of the categories on the menu.
            // Uses categories list.
            CategorySection(changeCategory: changeCurrentCategory),

            // 2nd section, section that holds item buttons according to whichever button was pressed in 1st section.
            // Uses menu list.
            //width: contextWidth * 0.6, // <-- Old
            MenuItemSection(addItemToOrder: addToOrder, categoryToBeDisplayed: currentCategory),

            // 3rd section, section that contains order information and buttons that apply to order.
            OrderSection(currentOrder: currentOrder, setEditItem: setItemToEdit)
          ]
        ),
      )
    );
  }
}