import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/timetable_list.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/services/auth_service.dart';
import 'package:teacher_portal/services/timetable_service.dart';
import 'package:teacher_portal/services/api_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime selectedDate = DateTime.now();

  String standard = "";
  String division = "";
  bool isLoading = true;
  List<dynamic> timetableEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    print("Fetching profile data...");

    var userData = await AuthService.getUserData();
    print("User data: $userData");

    if (userData != null &&
        userData["classAssigned"] != null &&
        userData["classAssigned"]["standard"] != null &&
        userData["classAssigned"]["division"] != null) {
      standard = userData["classAssigned"]["standard"];
      division = userData["classAssigned"]["division"];

      print("Standard: $standard, Division: $division");

      await _fetchTimetable();
    } else {
      print("User data missing standard or division");
      setState(() {
        standard = "N/A";
        division = "N/A";
        isLoading = false;
      });
    }
  }


  Future<void> _fetchTimetable() async {
    String weekday = DateFormat('EEEE').format(selectedDate);
    print("Fetching timetable for $standard-$division on $weekday");

    setState(() {
      isLoading = true;
    });

    try {
      var entries = await TimetableService.getTimetable(standard, division, weekday);
      print("Timetable entries fetched: ${entries.length}");

      setState(() {
        timetableEntries = entries;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching timetable: $e");
      setState(() {
        timetableEntries = [];
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _fetchTimetable(); // Refetch based on new date
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String formattedDate = DateFormat('dd MMMM yyyy').format(selectedDate);
    String weekday = DateFormat('EEEE').format(selectedDate);

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text(
                  "Time Table",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total Students: 50",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Standard & Division
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Standard: $standard",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
                Text(
                  "Division: $division",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Date Display (Clickable)
            Center(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weekday,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "(Tap to change date)",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Divider(),

            // 🔹 Timetable List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TimetableList(timetableEntries: timetableEntries),
            ),
          ],
        ),
      ),
    );
  }
}
