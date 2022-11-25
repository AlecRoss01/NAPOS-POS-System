import 'dart:io';
import 'dart:convert';
import 'dart:async';

//https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server

tcpClient() async {
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');

  // send hello
  socket.add(utf8.encode('GETMENU'));

  // listen to the received data event stream
  socket.listen((List<int> event) {
    print(utf8.decode(event));
  });

  // wait 5 seconds
  await Future.delayed(Duration(seconds: 5));

  // .. and close the socket
  socket.close();
}
