import 'package:napos/classes/order.dart';
import '../classes/menu_item.dart';
import '../classes/category.dart';

// Hardcoded menu
buildMenu(POS_Category category) {
  final menu = <MenuItem>[];
  final catMenu = <MenuItem>[];
  menu.add(MenuItem('Hot Dog', price: 1.25));
  menu.add(MenuItem("Pizza", price: 2.0));
  menu.add(MenuItem("Soup", price: 3.0));
  menu.add(MenuItem("Cheeseburger", price: 5.0));
  menu.add(MenuItem("Spaghetti", price: 4.0));
  menu.add(MenuItem("Coke", price: 1.0));
  menu.add(MenuItem("Rootbeer", price: 1.0));
  menu.add(MenuItem("Beer", price: 2.0));
  menu.add(MenuItem("Water", price: 0.0));
  menu.add(MenuItem("Ice Tea", price: 2.0));
  menu.add(MenuItem("T-Shirt", price: 20.0));
  menu.add(MenuItem("Hat", price: 10.0));
  menu.add(MenuItem("Hoodie", price: 25.0));
  menu.add(MenuItem("Sticker", price: 0.5));
  menu.add(MenuItem("Glassware", price: 5.0));
  
  for (var i = 0; i < 5; i++){
    menu[i].addCatTag("Food");
  }

  for (var i = 5; i < 10; i++){
    menu[i].addCatTag("Drinks");
  }

  for (var i = 10; i < 15; i++){
    menu[i].addCatTag("Merch");
  }

  // Returns full menu.
  if (category.name == 'All') {
    return menu;
  }

  for (var i = 0; i < menu.length; i++){
    if (menu[i].categories.contains(category.name)){
      catMenu.add(menu[i]);
    }
  }

  return catMenu;
}

// Hardcoded categories
buildCats() {
  final cat = <String>["Food", "Drinks", "Merch"];
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