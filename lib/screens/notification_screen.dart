import 'package:flutter/material.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/services/socket_service.dart';
import 'package:teacher_portal/Card/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    SocketService.clearNotificationBadge();
  }

  void removeNotification(int index) {
    if (index < 0 || index >= SocketService.notifications.length) return;

    final removedNotification = SocketService.notifications[index];

    setState(() {
      SocketService.notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Notification removed"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              SocketService.notifications.insert(index, removedNotification);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;
    final double spacing = screenHeight * 0.02;

    return MainLayout(
      selectedIndex: 0,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/home');
          return false;
        },
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(goHome: true),
              SizedBox(height: spacing),
              Divider(thickness: 2, color: Colors.blue, indent: padding, endIndent: padding),
              SizedBox(height: spacing),
              Expanded(
                child: SocketService.notifications.isEmpty
                    ? const Center(child: Text("No Notifications"))
                    : ListView.builder(
                  itemCount: SocketService.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = SocketService.notifications[index];
                    final message = notification["title"] ?? "Unknown Notification";
                    final date = notification["date"] ?? "--";

                    return Dismissible(
                      key: ValueKey(notification), // Ensure unique key
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Immediately remove notification before rebuilding
                        if (mounted) {
                          removeNotification(index);
                        }
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: NotificationCard(
                        index: index + 1,
                        title: message,
                        subtitle: notification["subtitle"] ?? "Click to view details",
                        date: date,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
