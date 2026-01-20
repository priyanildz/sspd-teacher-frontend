import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teacher_portal/services/auth_service.dart';


class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  String currentDate = DateFormat("dd MMMM yyyy").format(DateTime.now());
  String currentDay = DateFormat("EEEE").format(DateTime.now());

  List announcements = [];
  String selectedTab = "Inbox";

  @override
  void initState() {
    super.initState();
    fetchAnnouncements("Inbox");
  }

  Future<void> fetchAnnouncements(String type) async {
    String? token = await AuthService.getToken();
    String? std = await AuthService.getStd();
    String? className = await AuthService.getClassName();

    String url = "http://192.168.1.33:6000/api/announcements/get-announcement";

    if (type.toLowerCase() == "inbox") {
      url += "?status=inbox&std=$std&className=$className";
    } else if (type.toLowerCase() == "sent") {
      url += "?status=sent";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        selectedTab = type;
        announcements = jsonDecode(response.body);
      });
    } else {
      print("Failed to load announcements");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtonWidget(),
                  Text("Announcement", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  Text("$currentDate\n$currentDay", textAlign: TextAlign.right, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
                ],
              ),
            ),
            Divider(thickness: 1.h, color: Colors.grey),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    Icon(Icons.search, color: Colors.blue, size: 20.sp),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Search Announcements", border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final refreshed = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: SizedBox(
                                height: 0.75.sh,
                                child: AddAnnouncementForm(),
                              ),
                            );
                          },
                        );

                        if (refreshed == true) {
                          fetchAnnouncements(selectedTab);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(Icons.add, color: Colors.blue, size: 24.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                String type = index == 0 ? "Inbox" : index == 1 ? "Draft" : "Sent";
                fetchAnnouncements(type);
              },
              tabs: [
                Tab(text: "Inbox"),
                Tab(text: "Draft"),
                Tab(text: "Sent"),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AnnouncementList(title: "Inbox", data: announcements),
                  AnnouncementList(title: "Draft", data: announcements),
                  AnnouncementList(title: "Sent", data: announcements),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddAnnouncementForm extends StatefulWidget {
  const AddAnnouncementForm({super.key});

  @override
  State<AddAnnouncementForm> createState() => _AddAnnouncementFormState();
}

class _AddAnnouncementFormState extends State<AddAnnouncementForm> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _stdController = TextEditingController();
  final _classController = TextEditingController();

  String selectedValue = "V";

  Future<void> _handleSubmit(String type) async {
    final token = await AuthService.getToken();

    final payload = {
      "std": _stdController.text,
      "class": _classController.text,
      "publishTo": selectedValue,
      "subject": _subjectController.text,
      "message": _messageController.text,
      "type": type, // "send" or "draft"
    };

    final response = await http.post(
      Uri.parse("http://192.168.1.33:6000/announcements/${type == "send" ? "send" : "draft"}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Use actual token
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to $type announcement")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInputField(label: "Std", controller: _stdController, width: 140.w),
                _buildInputField(label: "Class", controller: _classController, width: 140.w),
              ],
            ),
            SizedBox(height: 8.h),
            Text("Publish to", style: TextStyle(fontSize: 14.sp)),
            DropdownButtonFormField<String>(
              value: selectedValue,
              items: ["Principal", "Teacher", "Finance", "Admin"].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 14.sp)),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedValue = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              ),
            ),
            SizedBox(height: 10.h),
            Text("Subject", style: TextStyle(fontSize: 14.sp)),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              ),
            ),
            SizedBox(height: 10.h),
            Text("Message", style: TextStyle(fontSize: 14.sp)),
            Container(
              height: 200.h,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _handleSubmit("draft"),
                  child: Text("Save Draft", style: TextStyle(fontSize: 14.sp)),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () => _handleSubmit("send"),
                  child: Text("Send", style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp)),
        SizedBox(
          width: width ?? double.infinity,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            ),
          ),
        ),
      ],
    );
  }
}

class AnnouncementList extends StatelessWidget {
  final String title;
  final List data;
  const AnnouncementList({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    String actionText = title == "Inbox" ? "Read More" : (title == "Draft" ? "Send" : "View");

    return ListView.builder(
      padding: EdgeInsets.all(8.w),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
          child: ListTile(
            leading: Container(
              width: 40.w,
              height: 60.h,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text("${index + 1}", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            ),
            title: Text(item["subject"] ?? "Announcement", style: TextStyle(fontSize: 14.sp)),
            subtitle: Text("${item["message"]} | ${item["date"] ?? ""}", style: TextStyle(fontSize: 12.sp)),
            trailing: Text(actionText, style: TextStyle(fontSize: 12.sp, color: Colors.blue)),
          ),
        );
      },
    );
  }
}
