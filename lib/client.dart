import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'menu_item.dart';
import 'order.dart';


//https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server

main() async {
  //var menu = await recvOrders();
  //for(var i = 0 ; i < menu.length ; i++ ){
  //   print(menu[i].itemName);
  //}
  //var menu = await recvMenu();
  //for(var i = 0 ; i < menu.length ; i++ ){
     //print(menu[i].name);
  //}
  //var order = Order(0, 'lambchops');
  //var id = await sendOrder(order);
  //print(id);
}


// https://stackoverflow.com/questions/63323038/dart-return-data-from-a-stream-subscription-block
Future<List<MenuItem>> recvMenu() async {
  // returns the menu as a list of strings
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
        menuList.add(MenuItem(0, dataList[i]));
  }
  socket.close();
  return menuList;
}


Future<int> sendOrder(Order order) async {
  //Sends order and adds it to order db
  Socket socket = await Socket.connect('127.0.0.1', 30000);
    print('connected');
    socket.add(utf8.encode('SENDORDER\n'));
    socket.add(utf8.encode(order.orderIDNullChar + '\n'));
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
      ordersList.add(Order(0, dataList[i]));
  }
  socket.close();
  return ordersList;
}

