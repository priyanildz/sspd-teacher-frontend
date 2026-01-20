import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:teacher_portal/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  late IO.Socket socket;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _loadMessages();
  }

  void _connectSocket() async {
    currentUserId = await AuthService.getUserId();

    socket = IO.io('http://192.168.1.33:6000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Connected to socket");
      socket.emit('join', currentUserId); // join room for this user
    });

    socket.on('receive_message', (data) {
      if ((data['senderId'] ?? '') == widget.receiverId) {
        if (!mounted) return;

        setState(() {
          _messages.add({
            'senderId': data['senderId'] ?? '',
            'receiverId': data['receiverId'] ?? '',
            'message': data['message'] ?? '',
            'timestamp': data['timestamp'] ?? DateTime.now().toString(),
          });
        });

        _scrollToBottom();
      }
    });
  }

  Future<void> _loadMessages() async {
    final token = await AuthService.getToken();

    final res = await http.get(
      Uri.parse("http://192.168.1.33:6000/api/messages/${widget.receiverId}"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body)['messages'];

      if (!mounted) return;
      setState(() {
        _messages = data
            .map((msg) => {
          'senderId': msg['senderId'] ?? '',
          'receiverId': msg['receiverId'] ?? '',
          'message': msg['message'] ?? '',
          'timestamp': msg['timestamp'] ?? '',
        })
            .cast<Map<String, dynamic>>()
            .toList();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      // ✅ Mark messages as read after loading
      _markMessagesAsRead();
    }
  }


  Future<void> _markMessagesAsRead() async {
    final token = await AuthService.getToken();

    await http.post(
      Uri.parse("http://192.168.1.33:6000/api/messages/mark-read/${widget.receiverId}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }


  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || currentUserId == null) return;

    final messageData = {
      'senderId': currentUserId,
      'receiverId': widget.receiverId,
      'message': text,
    };

    socket.emit('send_message', messageData);

    final token = await AuthService.getToken();
    await http.post(
      Uri.parse("http://192.168.1.33:6000/api/messages"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(messageData),
    );

    setState(() {
      _messages.add(messageData);
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.off('receive_message');
    socket.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = (msg['senderId'] ?? '') == (currentUserId ?? '');

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg['message'] ?? '', // 🧠 This will now correctly display the text
                      style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
