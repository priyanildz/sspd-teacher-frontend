import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teacher_portal/screens/main_layout.dart';
import 'chat_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';



class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map<String, dynamic>> teachers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTeachers();
  }

  Future<void> loadTeachers() async {
    try {
      final fetchedTeachers = await ApiService.fetchTeachers();

      final token = await AuthService.getToken();
      final summaryRes = await http.get(
        Uri.parse("http://192.168.1.33:6000/api/messages/summary/all"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final summaryData = jsonDecode(summaryRes.body)['conversations'];

      // Create a map of userId → summary
      final Map<String, dynamic> summaryMap = {
        for (var item in summaryData) item['userId']: item
      };

      // Merge summary with teachers list
      final mergedList = fetchedTeachers.map((teacher) {
        final userId = teacher['id'];
        final summary = summaryMap[userId] ?? {};

        // Check the messages and get the latest one from either the teacher or the other person
        final lastMessage = summary['messages']?.last ?? {};
        final latestMessage = (lastMessage['senderId'] == teacher['id'])
            ? lastMessage['message'] // Teacher's message
            : summary['lastMessage']; // Other person's message

        // Get the latest timestamp
        final timestamp = summary['messages']?.last['timestamp'] ?? summary['timestamp'];

        return {
          ...teacher,
          'unreadCount': summary['unreadCount'] ?? 0,
          'lastMessage': latestMessage ?? 'No messages',
          'timestamp': timestamp ?? '',
        };
      }).toList();

      setState(() {
        teachers = mergedList;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 2,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(teacher['name'] ?? 'Unknown'), // Display teacher's name
          trailing: (teacher['unreadCount'] ?? 0) > 0
              ? CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Text(
              '${teacher['unreadCount']}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
              : null,
            subtitle: Text(
              teacher['lastMessage'] ?? 'No messages yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          onTap: () async {
            // Mark as read and then navigate to chat screen
            final token = await AuthService.getToken();
            await http.post(
              Uri.parse("http://192.168.1.33:6000/api/messages/mark-read/${teacher['id']}"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            );

            // After marking as read, refresh the teacher list to update the unread count
            loadTeachers();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  receiverId: teacher['id'],
                  receiverName: teacher['name'],
                ),
              ),
            );
          },
          );
        },
      ),
    );
  }
}
