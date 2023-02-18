import 'package:napos/classes/order.dart';
import '../classes/menu_item.dart';
import '../classes/category.dart';

// Hardcoded menu
buildMenu(POS_Category category) {
  final menu = <MenuItem>[];
  final catMenu = <MenuItem>[];
  menu.add(MenuItem("Hot Dog", 1, 1.2));
  menu.add(MenuItem("Pizza", 2));
  menu.add(MenuItem("Soup", 3));
  menu.add(MenuItem("Cheeseburger", 4));
  menu.add(MenuItem("Spaghetti", 4));
  menu.add(MenuItem("Coke", 4));
  menu.add(MenuItem("Rootbeer", 4));
  menu.add(MenuItem("Beer", 4));
  menu.add(MenuItem("Water", 4));
  menu.add(MenuItem("Ice Tea", 4));
  menu.add(MenuItem("T-Shirt", 4));
  menu.add(MenuItem("Hat", 4));
  menu.add(MenuItem("Hoodie", 4));
  menu.add(MenuItem("Sticker", 4));
  menu.add(MenuItem("Glassware", 4));
  
  for (var i = 0; i < 5; i++){
    menu[i].addCatTag("Food");
  }

  for (var i = 5; i < 10; i++){
    menu[i].addCatTag("Drinks");
  }

  for (var i = 10; i < 15; i++){
    menu[i].addCatTag("Merch");
  }

  for (var i = 0; i < menu.length; i++){
    menu[i].addCatTag("All");
  }

  for (var i = 0; i < menu.length; i++){
    if (menu[i].categories.contains(category.name)){
      catMenu.add(menu[i]);
    }
  }

  return catMenu;
}

// Hardcoded categories
buildCat() {
  final cat = <String>["Food", "Drinks", "Merch", "All"];
  return cat;
}

// Hardcoded historical orders
List<Order> buildHistOrders() {
  var cat = new POS_Category("Food");
  final myMenu = buildMenu(cat);
  List<Order> histOrders = <Order>[];

  Order order1 = Order(1);
  order1.addItemToOrder(myMenu[0]);
  order1.addItemToOrder(myMenu[1]);
  histOrders.add(order1);

  return histOrders;
}