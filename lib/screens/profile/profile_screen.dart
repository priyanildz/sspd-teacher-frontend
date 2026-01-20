import 'package:flutter/material.dart';
import 'package:teacher_portal/widgets/profile_options.dart';
import 'package:teacher_portal/screens/profile/my_profile_screen.dart';
import 'package:teacher_portal/screens/profile/my_attendance_screen.dart';
import 'package:teacher_portal/screens/profile/leave_request.dart';
import 'package:teacher_portal/screens/profile/subject_class_screen.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/routes/app_routes.dart';
import 'package:teacher_portal/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0, // ✅ Keeps Bottom Bar visible
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/home'); // ✅ Back to Home
          return false;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ProfileHeader(goHome: true,),
            ),
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person, size: 50, color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Staff Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    title: "My Profile",
                    subtitle: "Keep Your Profile Details Updated",
                    onTap: () {
                      Navigator.pushNamed(context, '/my-profile');
                    },
                  ),
                  ProfileOption(
                    title: "My Attendance",
                    subtitle: "Keep Your Attendance Recorded",
                    onTap: () {
                      Navigator.pushNamed(context, '/my-attendance');
                    },
                  ),
                  ProfileOption(
                    title: "My Leave Request",
                    subtitle: "Apply Your Leave",
                    onTap: () {
                      Navigator.pushNamed(context, '/leave-request');
                    },
                  ),
                  ProfileOption(
                    title: "My Subject & Class",
                    subtitle: "View Your Subject and Class",
                    onTap: () {
                      Navigator.pushNamed(context, '/subject-class');
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the LoginScreen and remove all previous screens
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false, // Remove all previous routes
                );
              },
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
