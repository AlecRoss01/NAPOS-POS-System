import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:napos/classes/category.dart';
import 'package:square_in_app_payments/models.dart';
import '../classes/menu_item.dart';
import '../classes/order.dart';
import '../classes/employee.dart';
import '../classes/item_addition.dart';
import 'hardcoded_pos_data.dart';
import 'package:http/http.dart' as http;
//import 'package:http/http.dart'

// https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server
// https://stackoverflow.com/questions/63323038/dart-return-data-from-a-stream-subscription-block

const bool TESTING = false;
String connString = '184.171.150.182';

void setNewIP (String ip) {
  connString = ip;
}

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

Future<int> addItemToMenu(MenuItem item) async {
  // TODO add menu item to database.

  if (TESTING) {
    return 0;
  }

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest("ADDMENITEM"))));
  socket.add(utf8.encode(jsonEncode(item)));
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

//https://curlconverter.com/dart/
// below code is based on above link, must edit it to conform to necesarry specifications
String buildSquareCurl() {
  var headers = {
    'Square-Version': '2023-03-15',
    'Authorization': 'Bearer ACCESS_TOKEN',
    'Content-Type': 'application/json',
  };
  return "";
}
/*void buildSquareCurl() {
  var headers = {
    'Square-Version': '2023-03-15',
    'Authorization': 'Bearer ACCESS_TOKEN',
    'Content-Type': 'application/json',
  };

  var data = '{\n    "amount_money": {\n      "amount": 1759,\n      "currency": "USD"\n    },\n    "idempotency_key": "4a3b536c-f68b-4549-bc46-f3eb92c81b8d",\n    "source_id": "cnon:card-nonce-ok"\n  }';

  var url = Uri.parse('https://connect.squareupsandbox.com/v2/payments');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);

}*/

Future<int> removeItemInMenu(MenuItem item) async {
  // Note: Passed item may or may not exist in the database.

  if (TESTING) {
    return 0;
  }

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest("REMOVEMENITEM"))));
  socket.add(utf8.encode(jsonEncode(item)));
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

void replaceItemInMenu(MenuItem oldItem, MenuItem newItem) {
  removeItemInMenu(oldItem);
  addItemToMenu(newItem);
}

Future<int> addAdditionToMenu(ItemAddition addition) async {
  if (TESTING) {
    return 0;
  }

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest("ADDADDITION"))));
  socket.add(utf8.encode(jsonEncode(addition)));
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

Future<int> removeAdditionInMenu(ItemAddition addition) async {
  if (TESTING) {
    return 0;
  }

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest("REMOVEADDITION"))));
  socket.add(utf8.encode(jsonEncode(addition)));
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
  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode(jsonEncode(JsonRequest("MENU"))));
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
  Socket socket = await Socket.connect(connString, 30000);
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
  Socket socket = await Socket.connect(connString, 30000);
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
    //ordersList.add(Order.fromJson(mapDecode['Orders'][i]));
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
  Socket socket = await Socket.connect(connString, 30000);
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
      //ordersList.add(Order.fromJson(mapDecode['Orders'][i]));
    }
  }
  socket.close();
  return ordersList;
}

Future<List<Order>> recvIncompleteOrders() async {
  // TODO possibly restrict timeframe of orders in future (like past 24 hours).

  if (TESTING) {
    return await recvOrders();
  }

  var ordersList = <Order>[];
  Socket socket = await Socket.connect(connString, 30000);
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
    //ordersList.add(Order.fromJson(mapDecode['Orders'][i]));
  }
  socket.close();
  return ordersList;
}

Future<int> markOrderAsComplete(Order order, bool complete) async {
  if (TESTING) {
    return 0;
  }

  print('Marked as $complete');
  Socket socket = await Socket.connect(connString, 30000);
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

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  var output = "";
  var request = JsonRequest("CATEGORIES");
  socket.add(utf8.encode(jsonEncode(request)));
  await for (var data in socket) {
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  socket.close();
  var catList = <String>["All"];
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

  Socket socket = await Socket.connect(connString, 30000);
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
  if (TESTING) {
    return buildEmployees();
  }

  var employees = <NAPOS_Employee>[];
  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode(jsonEncode(JsonRequest("GETEMPLOYEES"))));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  if (mapDecode['Employees'] != null) {
    for (var i = 0; i < mapDecode['Employees'].length; i++) {
      employees.add(NAPOS_Employee.fromJson(mapDecode['Employees'][i]));
    }
  }
  socket.close();
  return employees;
}

Future<NAPOS_Employee> getEmployeeFromPin(int pin) async {
  var employees = await recvEmployees();
  for (int i = 0; i < employees.length; i++) {
    if (employees[i].pin == pin) {
      return employees[i];
    }
  }
  throw ("No employee found with that pin");
}

Future<Socket> makeConnection(String request) async {
  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  socket.add(utf8.encode(jsonEncode(JsonRequest(request))));
  return socket;
}

Future<List<ItemAddition>> recvItemAdditions() async {
  // Receive all item additions
  var additions = <ItemAddition>[];

  if (TESTING) {
    additions = buildItemAdditions();
    return additions;
  }

  Socket socket = await Socket.connect(connString, 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode(jsonEncode(JsonRequest("GETADDITIONS"))));
  await for (var data in socket) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var mapDecode = jsonDecode(output);
  if (mapDecode['All'] != null) {
    for (var i = 0; i < mapDecode['All'].length; i++) {
      additions.add(ItemAddition.fromJson(mapDecode['All'][i]));
    }
  }
  socket.close();
  return additions;
}

/* void recvJson() async {
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
}*/

const String squareApplicationId = "sandbox-sq0idb-VW7u7iB55ZYYzrKURZTGAg";
const String squareLocationId = "LKHJBQ2DPCJA7";
String chargeServerHost = "http://184.171.150.182:8000/chargeForNapos";
String accessToken =
    "EAAAEAcydw0WAP9TtI7Cv_MXItCe2EPzXzPmpjoQWCkK3rEd6MkEwM7TRDK8ahdq";
Uri chargeUrl = Uri.parse(chargeServerHost);

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(CardDetails result, double chargeAmount) async {
  // use result.nonce to get nonce
  var body = jsonEncode({"nonce": result.nonce, "charge": chargeAmount});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  print("I am about to retrieve a responsecode");
  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}

Order parseOrder(Map m) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(m['DateTime']);
  var order = Order(NAPOS_Employee.fromJson(m['OrderTaker']), dateTime: date);
  order.id = m['OrderID'];
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
  if (m['CatTags'] != null) {
    List<String> catTags = List<String>.from(m['CatTags'] as List);
    item.addCatTags(catTags);
  }
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

Future<String> getData(Socket sock) async {
  var output = "";
  await for (var data in sock) {
    //print(utf8.decode(data));
    output = utf8.decode(data);
    if (output == "finish") {
      return "finish";
    }
  }
  return output;
}

updateCatTags(MenuItem m) async {
  var sock = await makeConnection("UPDATECATTAGS");
  sock.add(utf8.encode(jsonEncode(m)));
  var data = await getData(sock);
  sock.close();
}

main() async {
  //var employee = NAPOS_Employee("Alec", 1, 1234, 4);
  //var order = Order(employee, id: 5);
  //var item = MenuItem("Fish Sticks", id: 3, price: 14.95);
  //item.addCatTag("Food");
  //order.addItemToOrder(item);
  //sendOrder(order);
  //var order = recvOrders();
  //addItemToMenu(item);
  //var adds = await recvItemAdditions();
}
