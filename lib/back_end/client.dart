import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../classes/menu_item.dart';
import '../classes/order.dart';
import '../classes/category.dart';
import 'hardcoded_pos_data.dart';

const bool TESTING = true;

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


Future<List<MenuItem>> recvMenu(POS_Category category) async {
  // returns the menu as a list of strings

  // Use hardcoded values.
  if(TESTING) {
    return buildMenu(category);
  }

  // Use values from server.
  var menuList = <MenuItem>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode('GETMENU\n'));
  await for (var data in socket){
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  var dataList = output.split(' ');
    for(var i = 0 ; i < dataList.length ; i++ ){
        menuList.add(MenuItem(dataList[i]));
  }
  socket.close();
  return menuList;
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
    socket.add(utf8.encode('SENDORDER\n'));
    socket.add(utf8.encode(order.toString() + '\n'));
    await for (var data in socket){
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
    //List<Order> myhistOrders = [Order(1, [MenuItem(1, "Test")])];
    return buildHistOrders();
  }

  // Use values from server.
  var ordersList = <Order>[];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode('GETORDERS\n'));
  await for (var data in socket){
      //print(utf8.decode(data));
      output = utf8.decode(data);
  }
  var dataList = output.split(' ');
  for(var i = 0 ; i < dataList.length ; i++ ){
    Order cur_order = Order(i);
    cur_order.addItemToOrder(MenuItem(dataList[i]));
    ordersList.add(cur_order);
  }
  socket.close();
  return ordersList;
}


Future<List<String>> recvCats() async {
  // returns the categories
  return buildCat(); // From hardcoded.
}