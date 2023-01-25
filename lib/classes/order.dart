import 'menu_item.dart';

/*
How will we do unique order numbers?
Businesses may have order numbering standards they already use.
Should we account for order numbers from before our system was implemented?
*/

// Parse int from string: https://stackoverflow.com/questions/15289447/is-there-a-better-way-to-parse-an-int-in-dart

class Order {

  // MEMBERS

  // Order ID
  String orderIDNullChar = '0';
  int orderIDLength = 5;
  int orderID = 0;

  List<MenuItem> orderItems = <MenuItem>[]; // Growable list of menu items

  // Initialization; takes an ID for now.
  Order(this.orderID);

  // METHODS

  List<MenuItem> getMenuItems() { return orderItems; }

  // Clears all items in the order.
  void clearOrderItems() { orderItems = <MenuItem>[]; }

  // Adds a single item to the order.
  void addItemToOrder(MenuItem item) { orderItems.add(item); }

  //Adds multiple items to the order.
  void addItemsToOrder(List<MenuItem> items) {
    for (var item in items) { addItemToOrder(item); }
  }

  // Clears order then adds the items.
  void setOrderItems(List<MenuItem> items) {
    clearOrderItems();
    addItemsToOrder(items);
  }

  // Remove an item at an index. Cannot remove by name or ID, there can be duplicates.
  void removeOrderItemAt(int index) { orderItems.removeAt(index); }

  // Sums the price of each menuItem
  double getSubTotal() {
    double sum = 0.0;
    for (var element in orderItems) { sum += element.price; }
    return sum;
  }

  // Returns string of order ID.
  String strOrderID() {
    return orderID.toString().padLeft(orderIDLength, orderIDNullChar);
  }

  // toString will return the string order ID.
  @override
  String toString() { return strOrderID(); }
}
