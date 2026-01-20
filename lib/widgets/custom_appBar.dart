import 'package:flutter/material.dart';
import 'package:teacher_portal/routes/app_routes.dart';
import 'package:teacher_portal/services/socket_service.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  void initState() {
    super.initState();
    SocketService.addListener(() {
      Future.microtask(() {
        if (mounted) {
          setState(() {}); // Runs AFTER the build phase is completed
        }
      });
    });
  }

  @override
  void dispose() {
    SocketService.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      elevation: 0,
      title: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
        child: Image.asset('assets/logo.jpeg', height: 40),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notifications).then((_) {
                  if (mounted) {
                    setState(() {
                      SocketService.clearNotificationBadge();
                    });
                  }
                });
              },
            ),
            if (SocketService.hasNewNotifications)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.profile),
        ),
      ],
    );
  }
}
