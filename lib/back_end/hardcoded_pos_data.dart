import 'package:napos/classes/order.dart';
import '../classes/menu_item.dart';

// Hardcoded menu
buildMenu() {
  final menu = <MenuItem>[];
  menu.add(MenuItem(1, "Hot Dog", 1.2));
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
List<Order> buildHistOrders() {
  final myMenu = buildMenu();
  List<Order> histOrders = <Order>[];

  Order order1 = Order(1);
  order1.addItemToOrder(myMenu[0]);
  order1.addItemToOrder(myMenu[1]);
  histOrders.add(order1);

  return histOrders;
}