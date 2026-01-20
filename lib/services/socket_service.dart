import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketService {
  static final List<Map<String, String>> notifications = [];
  static bool hasNewNotifications = false;
  static IO.Socket? socket;
  static final List<VoidCallback> _listeners = [];

  static void initialize() {
    socket = IO.io("http://192.168.1.33:6000", <String, dynamic>{
      'transports': ['websocket'],
    });

    socket?.onConnect((_) {
      print('Connected to WebSocket server');
    });

    socket?.on('new_event', (data) {
      notifications.insert(0, {
        "title": data['message'],
        "subtitle": "Click to view details",
        "date": DateTime.now().toString().substring(0, 10),
      });
      hasNewNotifications = true;
      _notifyListeners();
    });

    socket?.onDisconnect((_) {
      print('Disconnected from WebSocket server');
    });
  }

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  static void clearNotificationBadge() {
    hasNewNotifications = false;
    _notifyListeners();
  }
}
