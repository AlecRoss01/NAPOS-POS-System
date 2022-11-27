import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'menu_item.dart';
import 'order.dart';


//https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server

main() async {
  //var menu = await recvMenu();
  //print(menu);
  var order = Order(0, 'lambchops');
  var id = await sendOrder(order);
  print(id);
}


// https://stackoverflow.com/questions/63323038/dart-return-data-from-a-stream-subscription-block
recvMenu() async {
  // returns the menu as a list of strings
  var menuList = [];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  socket.add(utf8.encode('GETMENU\n'));
  await for (var data in socket){
    //print(utf8.decode(data));
    menuList.add(MenuItem(0, utf8.decode(data)));
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

recvOrders() async {
  // returns all orders in the order db
  var ordersList = [];
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  socket.add(utf8.encode('GETORDERS\n'));
  await for (var data in socket){
      //print(utf8.decode(data));
      ordersList.add(Order(0, utf8.decode(data)));
  }
  socket.close();
  return ordersList;
}

