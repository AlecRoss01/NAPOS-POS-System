import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:napos/classes/category.dart';

import '../classes/menu_item.dart';
import '../classes/order.dart';
import '../classes/employee.dart';
import '../classes/item_addition.dart';
import 'hardcoded_pos_data.dart';

const bool TESTING = true;

class JsonRequest {
  String requestType;
  JsonRequest(this.requestType);

  JsonRequest.fromJson(Map<String, dynamic> json)
      : requestType = json['RequestType'];

  Map<String, dynamic> toJson() => {
        'RequestType': requestType,
      };
}

// https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server
// https://stackoverflow.com/questions/63323038/dart-return-data-from-a-stream-subscription-block

/*
main() async {
  var orders = await recvOrders();
  for(var i = 0 ; i < orders.length ; i++ ){
     print(orders[i].itemName);
  }
  var menu = await recvMenu();
  for(var i = 0 ; i < menu.length ; i++ ){
     print(menu[i].name);
  }
  var order = Order(0, 'lambchops');
  var id = await sendOrder(order);
  print(id);
}
*/

void addItemToMenu(MenuItem item) {
  // TODO add menu item to database.
  //print('Added item');
}

void removeItemInMenu(MenuItem item) {
  // TODO remove menu item from database.
  // Note: Passed item may or may not exist in the database.
  //print('Removed item');
}

void replaceItemInMenu(MenuItem oldItem, MenuItem newItem) {
  removeItemInMenu(oldItem);
  addItemToMenu(newItem);
}

void addAdditionToMenu(ItemAddition addition) {
  // TODO add addition to database.
  //print('Added addition');
}

void removeAdditionInMenu(ItemAddition addition) {
  // TODO remove addition from database.
  //print('Removed addition');
}

void replaceAdditionInMenu(ItemAddition oldAddition, ItemAddition newAddition) {
  removeAdditionInMenu(oldAddition);
  addAdditionToMenu(newAddition);
}

Future<List<MenuItem>> recvMenu() async {
  // returns the menu as a list of strings

  // Use hardcoded values.
  if (TESTING) {
    return buildMenu(POS_Category('All'));
  }

  // Use values from server.
  var menuList = <MenuItem>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode(jsonEncode(new JsonRequest("MENU"))));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  for (var i = 0; i < mapDecode['MenuItems'].length; i++) {
    menuList.add(parseItem(mapDecode['MenuItems'][i]));
  }
  socket.close();
  return menuList;
}

Future<List<MenuItem>> recvMenuCat(POS_Category p) async {
  // returns the menu as a list of strings

  // Use hardcoded values.
  if (TESTING) {
    return buildMenu(p);
  }

  // Use values from server.
  var catMenuList = <MenuItem>[];
  var menuList = await recvMenu();

  // Returns full menu.
  if (p.name == "All") {
    return menuList;
  }

  for (var i = 0; i < menuList.length; i++) {
    if (menuList[i].categories.contains(p.name)) {
      catMenuList.add(menuList[i]);
    }
  }
  return catMenuList;
}

Future<int> sendOrder(Order order) async {
  //Sends order and adds it to order db

  // Use hardcoded values.
  if (TESTING) {
    return 0;
  }

  // Use values from server.
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest("SENDORDER"))));
  socket.add(utf8.encode(jsonEncode(order)));
  await for (var data in socket) {
    //print(utf8.decode(data));
    if (utf8.decode(data) == "finish") {
      socket.close();
      return 0;
    }
  }
  socket.close();
  return 0;
}

Future<List<Order>> recvOrders() async {
  // returns all orders in the order db

  // Use hardcoded values.
  if (TESTING) {
    return buildHistOrders();
  }

  // Use values from server.
  var ordersList = <Order>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = new JsonRequest("ORDERS");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  for (var i = 0; i < mapDecode['Orders'].length; i++) {
    ordersList.add(parseOrder(mapDecode['Orders'][i]));
  }
  socket.close();
  return ordersList;
}

Future<List<Order>> recvCompleteOrders() async {
  // TODO receive all complete orders from the db.
  // TODO possibly restrict timeframe of orders in future (like past 24 hours).

  if (TESTING) {
    return await recvOrders();
  }

  var ordersList = <Order>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = new JsonRequest("GETCOMPLETEORDERS");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  if (mapDecode['Orders'] != null) {
    for (var i = 0; i < mapDecode['Orders'].length; i++) {
      ordersList.add(parseOrder(mapDecode['Orders'][i]));
    }
  }
  socket.close();
  return ordersList;
}

Future<List<Order>> recvIncompleteOrders() async {
  // TODO receive all incomplete orders from the db.
  // TODO possibly restrict timeframe of orders in future (like past 24 hours).
  //return await recvOrders();

  if (TESTING) {
    return await recvOrders();
  }

  var ordersList = <Order>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = new JsonRequest("GETINCOMPLETEORDERS");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  for (var i = 0; i < mapDecode['Orders'].length; i++) {
    ordersList.add(parseOrder(mapDecode['Orders'][i]));
  }
  socket.close();
  return ordersList;
}

Future<int> markOrderAsComplete(Order order, bool complete) async {
  // TODO update an order as completed or uncompleted.
  // TODO bool complete is true if order should be marked as complete. False if it should be marked as incomplete.

  if (TESTING) {
    return 0;
  }

  print('Marked as $complete');
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = new JsonRequest("MARKCOMPLETE");
  socket.add(utf8.encode(jsonEncode(request)));
  socket.add(utf8.encode(jsonEncode(order)));
  await for (var data in socket) {
    if (utf8.decode(data) == "finish") {
      socket.close();
      return 0;
    }
  }
  socket.close();
  return -1;
}

Future<List<String>> recvCats() async {
  // returns the categories
  if (TESTING) {
    return buildCats();
  }

  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = JsonRequest("CATEGORIES");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  socket.close();
  var catList = <String>[];
  for (var i = 0; i < mapDecode['Categories'].length; i++) {
    catList.add(mapDecode['Categories'][i]);
  }
  return catList;
}

Future<bool> checkPINNumbers(int pin) async {
  // call recvEmployees amd check each pin from list it returns

  if (TESTING) {
    return checkHardcodedPinNumbers(pin);
  }

  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var package = {'PIN': pin};
  var request = new JsonRequest("PINCHECK");
  socket.add(utf8.encode(jsonEncode(request)));
  socket.add(utf8.encode(jsonEncode(package)));
  await for (var data in socket) {
    var decode = utf8.decode(data);
    var json = jsonDecode(decode);
    if (json['PIN'] == pin) {
      socket.close();
      return true;
    } else {
      socket.close();
      return false;
    }
  }
  socket.close();
  return false;
}

Future<List<NAPOS_Employee>> recvEmployees() async {

  if(TESTING) {
    return buildEmployees();
  }

  //TODO: get employees from server
  var employees = <NAPOS_Employee>[];
  return employees;
}

Future<NAPOS_Employee> getEmployeeFromPin(int pin) async {
  var employees = await recvEmployees();
  for (int i = 0; i < employees.length; i++) {
    if (employees[i].pin == pin) {
      return employees[i];
    }
  }
  throw("No employee found with that pin");
}

Future<List<ItemAddition>> recvItemAdditions() async {
  // Receive all item additions
  var additions = <ItemAddition>[];

  if (TESTING) {
    additions = buildItemAdditions();
  }

  return additions;
}

void recvJson() async {
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var request = JsonRequest("ORDERS");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  //parseOrder(output);
  socket.close();
}

Order parseOrder(Map m) {
  var order = Order(m['OrderID']);
  order.orderIDNullChar = m['OrderIDNullChar'];
  order.idLength = m['OrderIDLength'];
  var items = <MenuItem>[];
  for (var i = 0; i < m['OrderItems'].length; i++) {
    items.add(parseItem(m['OrderItems'][i]));
  }
  order.setOrderItems(items);
  return order;
}

MenuItem parseItem(Map m) {
  var item = MenuItem(m['Name'], id: m['Id'], price: m['Price'].toDouble());
  //item.setPrice();
  // got line below from https://stackoverflow.com/questions/60105956/how-to-cast-dynamic-to-liststring
  List<String> catTags = List<String>.from(m['CatTags'] as List);
  item.addCatTags(catTags);
  return item;
}

convertHashtoList(MenuItem m) {
  var len = m.categories.length;
  List<String> tags = List<String>.filled(len, "");
  for (var i = 0; i < m.categories.length; i++) {
    tags[i] = m.categories.elementAt(i);
  }
  return tags;
}

/*void send() async {
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  var order = new Order(1);
  var item = new MenuItem("pasta", 1, 14.95);
  item.addCatTag("food");
  item.addCatTag("drink");
  print(convertHashtoList(item));
  order.addItemToOrder(item);
  order.addItemToOrder(item);
  var orderList = List<String>.filled(1, "stuff");
  var encodedOrder = jsonEncode(item);
  socket.add(utf8.encode(jsonEncode(new JsonRequest("SENDMENU"))));
  //var encodedOrder = {'OrderIDNullChar' : order.orderIDNullChar, 'OrderIDLength' : order.orderIDLength, 'OrderID' : order.orderID, 'OrderItems' : order.orderItems};
  // issue seems to be because of vector, so I need a function to  convert the vector to a list, then I should be able to handle things normally
  socket.add(utf8.encode(encodedOrder));
  await for (var data in socket){
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  socket.close();
}*/
