import 'menu_item.dart';
import 'dart:convert';
import 'employee.dart';
import 'package:intl/intl.dart';

// Parse int from string: https://stackoverflow.com/questions/15289447/is-there-a-better-way-to-parse-an-int-in-dart

class Order {
  /*
  Represents an order placed by a customer.
  */

  String orderIDNullChar = '0';
  int idLength = 5;
  int id = 0;
  NAPOS_Employee orderTaker;
  DateTime _dateTime;

  List<MenuItem> orderItems = <MenuItem>[]; // Growable list of menu items

  Order(
    this.orderTaker,
    {
    this.id = 0,
    DateTime? dateTime,
    }
  )
  : _dateTime = dateTime ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'OrderIDNullChar': orderIDNullChar,
    'OrderIDLength': idLength,
    'OrderID': id,
    'OrderItems': jsonEncode(orderItems),
    'OrderTaker': jsonEncode(orderTaker),
    'DateTime': dateTimeMilli,
  };

  List<MenuItem> getOrderItems() {
    return orderItems;
  }

  MenuItem getItemAtIndex(int index) {
    return orderItems[index];
  }

  int getOrderLength() {
    return orderItems.length;
  }

  void clearOrderItems() {
    orderItems = <MenuItem>[];
  }

  void addItemToOrder(MenuItem item) {
    orderItems.add(item);
  }

  void removeItemFromOrder(MenuItem item) {
    orderItems.remove(item);
  }

  void addItemsToOrder(List<MenuItem> items) {
    for (var item in items) {
      addItemToOrder(item);
    }
  }

  void setOrderItems(List<MenuItem> items) {
    clearOrderItems();
    addItemsToOrder(items);
  }

  // Remove an item at an index. Cannot remove by name or ID, there can be duplicates.
  void removeOrderItemAt(int index) {
    orderItems.removeAt(index);
  }

  String get dateTimeStr {
    DateFormat formatterDate = DateFormat('MM-dd-yyyy');
    DateFormat formatterTime = DateFormat('jm');
    return '${formatterTime.format(_dateTime)}   ${formatterDate.format(_dateTime)}';
    //return '';
  }

  int get dateTimeMilli {
    return _dateTime.millisecondsSinceEpoch;
  }

  double getSubTotal() {
    double sum = 0.0;
    for (var element in orderItems) {
      sum += element.price;
    }
    return sum;
  }

  // String of subtotal with USD sign and to two decimals.
  String strSubTotal() {
    return "\$${getSubTotal().toStringAsFixed(2)}";
  }

  String strOrderID() {
    return id.toString().padLeft(idLength, orderIDNullChar);
  }

  @override
  String toString() {
    return strOrderID();
  }

  // If they have the same ID, they are equal.
  @override
  bool operator ==(Object o) {
    if (o is Order) {
      return o.id == id;
    }
    return false;
  }
}
