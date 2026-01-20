import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teacher_portal/widgets/CustomTextField.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/services/auth_service.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _assignedClassController =
      TextEditingController();

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        print("❌ No token found");
        setState(() => _hasError = true);
        return;
      }

      final response = await http.get(
        Uri.parse("https://sspd-teacher-backend.vercel.app/api/auth/profile"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"]) {
          final user = data["user"];

          setState(() {
            _nameController.text = user["name"] ?? "Unknown";
            _emailController.text = user["emailaddress"] ?? "No Email";
            _contactController.text = user["contact"] ?? "No Contact";
            // _dobController.text = user["dob"] ?? "No DOB";
            String rawDob = user["dob"] ?? "";
            if (rawDob.contains('T')) {
              // If it's still an ISO string, format it here
              DateTime dt = DateTime.parse(rawDob);
              _dobController.text =
                  "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
            } else {
              _dobController.text = rawDob;
            }
            _usernameController.text = user["username"] ?? "No Username";

            if (user["classAssigned"] != null &&
                user["classAssigned"]["standard"] != null &&
                user["classAssigned"]["division"] != null) {
              _assignedClassController.text =
                  "${user["classAssigned"]["standard"]} - ${user["classAssigned"]["division"]}";
            } else {
              _assignedClassController.text = "Not Assigned";
            }

            _isLoading = false;
          });

          await AuthService.saveUserData(user);

          // ✅ NEW: Store class info separately
          if (user["classAssigned"] != null) {
            await AuthService.saveStd(user["classAssigned"]["standard"]);
            await AuthService.saveClassName(user["classAssigned"]["division"]);
          }
        } else {
          print("❌ API Error: ${data["message"]}");
          setState(() => _hasError = true);
        }
      } else {
        print("❌ Server Error: ${response.statusCode}");
        setState(() => _hasError = true);
      }
    } catch (error) {
      print("❌ Profile Fetch Error: $error");
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                ? const Center(child: Text("Failed to load profile data"))
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileHeader(),
                      const SizedBox(height: 20),

                      // Profile Avatar
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Profile Info
                      CustomTextField(
                        label: "Name",
                        controller: _nameController,
                        isReadOnly: true,
                      ),
                      CustomTextField(
                        label: "DOB",
                        controller: _dobController,
                        isReadOnly: true,
                      ),
                      CustomTextField(
                        label: "E-mail",
                        controller: _emailController,
                        isReadOnly: true,
                      ),
                      CustomTextField(
                        label: "Contact No",
                        controller: _contactController,
                        isReadOnly: true,
                      ),
                      CustomTextField(
                        label: "Username",
                        controller: _usernameController,
                        isReadOnly: true,
                      ),

                      // Assigned Class (Formatted Correctly)
                      CustomTextField(
                        label: "Assigned Class",
                        controller: _assignedClassController,
                        isReadOnly: true,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
