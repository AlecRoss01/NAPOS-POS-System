import 'package:napos/classes/order.dart';
import '../classes/menu_item.dart';

// Hardcoded menu
buildMenu() {
  final menu = <MenuItem>[];
  menu.add(MenuItem("Hot Dog", 1, 1.2));
  menu.add(MenuItem("Pizza", 2));
  menu.add(MenuItem("Soup", 3));
  menu.add(MenuItem("Cheeseburger", 4));
  menu.add(MenuItem("Item", 4));
  menu.add(MenuItem("Item", 4));
  menu.add(MenuItem("Item", 4));
  menu.add(MenuItem("Item", 4));
  menu.add(MenuItem("Item", 4));
  menu.add(MenuItem("Item", 4));

  return menu;
}

// Hardcoded categories
buildCat() {
  final cat = <String>["Food", "Drinks", "Merch"];
  return cat;
}

// Hardcoded historical orders
List<Order> buildHistOrders() {
  final myMenu = buildMenu();
  List<Order> histOrders = <Order>[];

  Order order1 = Order(1);
  order1.addItemToOrder(myMenu[0]);
  order1.addItemToOrder(myMenu[1]);
  histOrders.add(order1);

  return histOrders;
}