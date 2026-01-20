import 'package:flutter/material.dart';
import 'package:teacher_portal/widgets/custom_appBar.dart';
import 'package:teacher_portal/routes/app_routes.dart';

class MainLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget child;

  const MainLayout({super.key, required this.child, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    String route = AppRoutes.home;
    if (index == 1) {
      route = AppRoutes.mySchedule;
    } else if (index == 2) {
      route = AppRoutes.messages;
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex == 0) {
          return true; // ✅ Allow exiting the app when on Home
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home); // ✅ Redirect to Home instead of exiting
          return false;
        }
      },
      child: Scaffold(
        appBar: const CustomAppbar(),
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          ],
        ),
      ),
    );
  }
}
