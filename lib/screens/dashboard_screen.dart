import 'package:flutter/material.dart';
import 'package:teacher_portal/widgets/custom_appBar.dart';
import 'package:teacher_portal/widgets/dashboard_tile.dart';
import 'package:teacher_portal/routes/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: screenHeight * 0.3, // Responsive height
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/school_bg.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.05,
                  child: Text(
                    "Hello Miss Professor,",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.07,
                  right: screenWidth * 0.05,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "15 Feb 2025 | Sat",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // Academic Year Container
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Academic Year 2025-2026",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Dashboard Tiles
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = screenWidth > 600 ? 4 : 3; // Adjust based on screen width

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DashboardTile(icon: Icons.checklist, title: "Class Attendance", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.attendance);
                    }),
                    DashboardTile(icon: Icons.calendar_today, title: "Class Time Table", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.timeTable);
                    }),
                    DashboardTile(icon: Icons.emoji_events, title: "Class Report Card", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.classReport);
                    }),
                    DashboardTile(icon: Icons.assignment, title: "Test Record", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.testRecord);
                    }),
                    DashboardTile(icon: Icons.list_alt, title: "Syllabus Tracker", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.syllabusTracker);
                    }),
                    DashboardTile(icon: Icons.attach_money, title: "Fees Record", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.feesRecord);
                    }),
                    DashboardTile(icon: Icons.event, title: "Events", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.event);
                    }),
                    DashboardTile(icon: Icons.campaign, title: "Announcements", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.announcement);
                    }),
                    DashboardTile(icon: Icons.edit_calendar, title: "Exams Schedule", onTap: () {
                      Navigator.pushNamed(context, AppRoutes.exam);
                    }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
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
