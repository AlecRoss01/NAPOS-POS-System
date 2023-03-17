import 'package:napos/classes/order.dart';
import '../classes/menu_item.dart';
import '../classes/category.dart';
import '../classes/item_addition.dart';

bool checkHardcodedPinNumbers(int pin) {
  var pinNumbersWithAccess = <int>[
    1234,
    5678,
    2233,
    0904,
    4582,
    7243,
    9999,
    0000,
    2321
  ];
  if (pinNumbersWithAccess.contains(pin)) {
    return true;
  }
  else {
    return false;
  }
}

buildItemAdditions() {
  final itemAdditions = <ItemAddition>[];
  itemAdditions.add(ItemAddition('Onions', 1, 0.5));
  itemAdditions.add(ItemAddition('Lettuce', 2, 0.5));
  itemAdditions.add(ItemAddition('Tomato', 3, 0.5));
  itemAdditions.add(ItemAddition('Pickles', 4, 0.5));
  itemAdditions.add(ItemAddition('Avocado', 5, 1));
  itemAdditions.add(ItemAddition('Mushrooms', 6, 0.5));
  itemAdditions.add(ItemAddition('Jalepenos', 7, 1));
  itemAdditions.add(ItemAddition('Bean Sprouts', 8, 0.5));
  itemAdditions.add(ItemAddition('Ketchup', 9, 0.5));
  itemAdditions.add(ItemAddition('Mustard', 10, 0.5));
  itemAdditions.add(ItemAddition('Pepperoni', 11, 2));
  itemAdditions.add(ItemAddition('Sausage', 12, 2));
  itemAdditions.add(ItemAddition('Cheese', 13, 1));
  return itemAdditions;
}


// Hardcoded menu
buildMenu(POS_Category category) {
  final menu = <MenuItem>[];
  final catMenu = <MenuItem>[];
  menu.add(MenuItem('Hot Dog', price: 1.25));
  menu.add(MenuItem("Pizza", price: 2.0));
  menu.add(MenuItem("Soup", price: 3.0));
  menu.add(MenuItem("Hamburger Cheeseburger Big Mac Whopper", price: 500.0));
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
  final cat = <String>["All", "Food", "Drinks", "Merch"];
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

  Order order2 = Order(2);
  order2.addItemToOrder(myMenu[0]);
  order2.addItemToOrder(myMenu[1]);
  histOrders.add(order2);

  return histOrders;
}

