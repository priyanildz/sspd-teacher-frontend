import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class MessageSocketService {
  static IO.Socket? socket;
  static String? userId;
  static final List<VoidCallback> _listeners = [];

  static void initialize(String currentUserId) {
    userId = currentUserId;

    socket = IO.io("http://192.168.1.33:6000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    socket?.onConnect((_) {
      print("📩 Connected to Messaging Socket");

      // Join personal room
      socket?.emit("join", userId);
    });

    socket?.on("private_message", (data) {
      print("📥 Message received: $data");
      _notifyListeners(); // UI updates
    });

    socket?.onDisconnect((_) {
      print("📴 Disconnected from Messaging Socket");
    });
  }

  static void sendMessage({
    required String toUserId,
    required String message,
  }) {
    if (socket?.connected == true) {
      socket?.emit("private_message", {
        "to": toUserId,
        "message": message,
      });
    } else {
      print("❗Socket not connected");
    }
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
}
