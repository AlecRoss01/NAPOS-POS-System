import 'menu_item.dart';
import 'dart:convert';
import 'employee.dart';
import 'package:intl/intl.dart';

/*
How will we do unique order numbers?
Businesses may have order numbering standards they already use.
Should we account for order numbers from before our system was implemented?
*/

// Parse int from string: https://stackoverflow.com/questions/15289447/is-there-a-better-way-to-parse-an-int-in-dart

class Order {

  // MEMBERS

  String orderIDNullChar = '0';
  int idLength = 5;
  int id = 0;
  NAPOS_Employee orderTaker;
  DateTime _dateTime;

  List<MenuItem> orderItems = <MenuItem>[]; // Growable list of menu items

  // Initialization; takes an ID for now.
  Order(
      this.orderTaker,

      // Optional parameters.
      {
        this.id = 0,
        DateTime? dateTime,
      }
  )
  : _dateTime = dateTime ?? DateTime.now();

  // METHODS

  Map<String, dynamic> toJson() => {
    'OrderIDNullChar' : orderIDNullChar,
    'OrderIDLength' : idLength,
    'OrderID' : id,
    'OrderItems' : jsonEncode(orderItems),
  };

  List<MenuItem> getOrderItems() { return orderItems; }

  MenuItem getItemAtIndex(int index) { return orderItems[index]; }

  int getOrderLength() { return orderItems.length; }

  // Clears all items in the order.
  void clearOrderItems() { orderItems = <MenuItem>[]; }

  // Adds a single item to the order.
  void addItemToOrder(MenuItem item) { orderItems.add(item); }

  //Remove a single item from the order
  void removeItemFromOrder(MenuItem item) { orderItems.remove(item); }

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

  String get dateTimeStr {
    DateFormat formatterDate = DateFormat('MM-dd-yyyy');
    DateFormat formatterTime = DateFormat('jm');
    return '${formatterTime.format(_dateTime)}   ${formatterDate.format(_dateTime)}';
    //return '';
  }

  int get dateTimeMilli {
    return _dateTime.millisecondsSinceEpoch;
  }

  // Sums the price of each menuItem
  double getSubTotal() {
    double sum = 0.0;
    for (var element in orderItems) { sum += element.price; }
    return sum;
  }

  // String of subtotal with USD sign and to two decimals.
  String strSubTotal() {
    return "\$${getSubTotal().toStringAsFixed(2)}";
  }

  // Returns string of order ID.
  String strOrderID() {
    return id.toString().padLeft(idLength, orderIDNullChar);
  }

  // toString will return the string order ID.
  @override
  String toString() { return strOrderID(); }

  // Override the == operator, if they have the same ID, they are equal.
  @override
  bool operator ==(Object o) {
    if (o is Order) {
      return o.id == id;
    }
    return false;
  }
}
