import 'menu_item.dart';

/*
How will we do unique order numbers?
Businesses may have order numbering standards they already use.
Should we account for order numbers from before our system was implemented?
*/

// Parse int from string: https://stackoverflow.com/questions/15289447/is-there-a-better-way-to-parse-an-int-in-dart

class Order {

  // Order ID
  String orderIDNullChar = '0';
  int orderIDLength = 10;
  int orderID = 0;

  final orderItems = <MenuItem>[]; // Growable list of menu items

  // Initialization takes an ID for now.
  Order(this.orderID, this.orderIDNullChar);

  // Returns string of order ID.
  String strOrderID() {
    return orderID.toString().padLeft(orderIDLength, orderIDNullChar);
  }

  // toString will return the string order ID.
  @override
  String toString() {
    return strOrderID();
  }
}
