import 'dart:io';
import 'dart:convert';
import 'dart:async';

//https://stackoverflow.com/questions/54481818/how-to-connect-flutter-app-to-tcp-socket-server

main() async {
  // Start of core TCP connection
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  // send GETMENU, which will get back a list of bytes that have the menu in them
  socket.add(utf8.encode('GETMENU\n'));

  // listen to the received data event stream
  socket.listen((List<int> event) {
    print(utf8.decode(event));
  });

  socket.add(utf8.encode('STOP\n'));
  // .. and close the socket
  socket.close();
  //End of core TCP connection
}
