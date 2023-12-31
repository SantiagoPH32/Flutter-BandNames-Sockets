import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://192.168.0.145:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.onConnect((_) {
      print('Conectado al servidor');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      print('Desconectado del servidor');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
