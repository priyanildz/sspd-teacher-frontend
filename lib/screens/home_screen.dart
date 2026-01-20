import 'package:flutter/material.dart';
import 'package:teacher_portal/widgets/dashboard_tile.dart';
import 'package:flutter/services.dart';
import 'package:teacher_portal/screens/main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop(); // Closes app on Android
          return false; // Prevents default navigation
    },
      child: MainLayout(
        selectedIndex: 0 ,
     child:  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/school_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 20,
                child: Text(
                  "Hello Miss Professor,",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "15 Feb 2025 | Sat",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Academic Year 2025-2026",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [

                DashboardTile(
                    icon: Icons.checklist,
                    title: "Class Attendance" ,
                    onTap: () {
                     Navigator.pushNamed(context, '/attendance');
                }),
                DashboardTile(
                    icon: Icons.calendar_today,
                    title: "Class Time Table",
                    onTap: () {
                      Navigator.pushNamed(context, '/time-table');
                    }),
                DashboardTile(
                    icon: Icons.emoji_events,
                    title: "Class Report Card",
                    onTap: () {
                      Navigator.pushNamed(context, '/class-report');

                    }),
                DashboardTile(
                    icon: Icons.assignment,
                    title: "Test Record",
                    onTap: () {
                      Navigator.pushNamed(context, '/test-record');

                }),
                DashboardTile(
                    icon: Icons.list_alt,
                    title: "Syllabus Tracker",
                    onTap: () {
                      Navigator.pushNamed(context, '/syllabus-tracker');
                    }),
                DashboardTile(
                    icon: Icons.attach_money,
                    title: "Fees Record",
                    onTap: () {
                      Navigator.pushNamed(context, '/fees-record');
                    }),
                DashboardTile(
                    icon: Icons.event,
                    title: "Events",
                    onTap: () {
                      Navigator.pushNamed(context, '/event');
                    }),
                DashboardTile(
                    icon: Icons.campaign,
                    title: "Announcements",
                    onTap: () {
                      Navigator.pushNamed(context, '/announcement');
                    }),
                DashboardTile(
                    icon: Icons.edit_calendar,
                    title: "Exams Schedule",
                    onTap: () {
                      Navigator.pushNamed(context, '/exam');
                    }),
              ],
            ),

          ),
        ],
      ),
    )
    )
      );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}