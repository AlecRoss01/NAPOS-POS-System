import 'package:napos/order.dart';

import 'menu_item.dart';

// Hardcoded menu
buildMenu() {
  final menu = <MenuItem>[];
  menu.add(MenuItem(1, "Hot Dog"));
  menu.add(MenuItem(2, "Pizza"));
  menu.add(MenuItem(3, "Soup"));
  menu.add(MenuItem(4, "Cheeseburger"));
  menu.add(MenuItem(4, "Item"));
  menu.add(MenuItem(4, "Item"));
  menu.add(MenuItem(4, "Item"));
  menu.add(MenuItem(4, "Item"));
  menu.add(MenuItem(4, "Item"));
  menu.add(MenuItem(4, "Item"));

  return menu;
}

// Hardcoded categories
buildCat() {
  final cat = <String>["Food", "Drinks", "Merch"];
  return cat;
}

// Hardcoded historical orders
buildHistOrders() {
  final histOrders = <Order>[];
  histOrders.add(Order(1, "Maruchan Ramen Noodles"));
  histOrders.add(Order(2, "Beesechurger"));
  histOrders.add(Order(3, "Pizzap"));
  return histOrders;
}