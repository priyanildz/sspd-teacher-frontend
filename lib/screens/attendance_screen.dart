import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/student_tile.dart';
import '../widgets/attendance_toggle.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/services/auth_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, Map<int, int>> attendanceData = {
    "Day": { for (var i in List.generate(50, (index) => index)) i : 0 }, // Default to absent (0)
    "Week": {},
    "Month": {},
  };

  String selectedToggle = "Day";
  String standard = "";
  String division = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    var userData = await AuthService.getUserData();
    if (userData != null &&
        userData["classAssigned"] != null &&
        userData["classAssigned"]["standard"] != null &&
        userData["classAssigned"]["division"] != null) {
      setState(() {
        standard = userData["classAssigned"]["standard"];
        division = userData["classAssigned"]["division"];
        isLoading = false;
      });
    } else {
      setState(() {
        standard = "N/A";
        division = "N/A";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = screenWidth / 400;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 1,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const BackButtonWidget(),
              Text("Attendance",
                  style: TextStyle(fontSize: 20 * scaleFactor, fontWeight: FontWeight.bold)),
              Text("Total Students: 50", style: TextStyle(fontSize: 16 * scaleFactor)),
            ]),
            SizedBox(height: screenHeight * 0.01),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Standard: $standard", style: TextStyle(fontSize: 16 * scaleFactor)),
                Text("Division: $division", style: TextStyle(fontSize: 16 * scaleFactor)),
              ]),
              AttendanceToggle(
                selectedToggle: selectedToggle,
                onToggleChanged: (newToggle) => setState(() => selectedToggle = newToggle),
              ),
            ]),
            SizedBox(height: screenHeight * 0.015),

            Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(formattedDate, style: TextStyle(fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
              Text(weekday, style: TextStyle(fontSize: 14 * scaleFactor, color: Colors.grey)),
            ])),
            SizedBox(height: screenHeight * 0.015),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildHeader(scaleFactor),
              _buildAttendanceLegend(scaleFactor),
            ]),
            const Divider(),

            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 12 * scaleFactor),
                  decoration: InputDecoration(
                    hintText: "Search Student",
                    hintStyle: TextStyle(fontSize: 12 * scaleFactor),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor, vertical: 8 * scaleFactor),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search), iconSize: 20 * scaleFactor),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor, vertical: 8 * scaleFactor),
                  minimumSize: const Size(0, 0),
                ),
                child: Text("Submit", style: TextStyle(fontSize: 12 * scaleFactor)),
              ),
            ]),
            SizedBox(height: screenHeight * 0.015),

            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  attendanceData.putIfAbsent("Day", () => {});
                  attendanceData.putIfAbsent("Week", () => {});
                  attendanceData.putIfAbsent("Month", () => {});

                  int presentCount;
                  int absentCount;

                  if (selectedToggle == "Day") {
                    presentCount = attendanceData["Day"]?[index] ?? 1;
                    absentCount = 1 - presentCount;
                  } else if (selectedToggle == "Week") {
                    presentCount = attendanceData["Week"]?[index] ?? 5;
                    absentCount = 6 - presentCount;
                  } else {
                    List<int> presentValues = [20, 19, 15, 17, 25, 24, 25, 24];
                    List<int> absentValues = [5, 6, 10, 8, 0, 1, 0, 1];

                    presentCount = presentValues[index % presentValues.length];
                    absentCount = absentValues[index % absentValues.length];
                  }

                  return StudentTile(
                    index: index,
                    isDayView: selectedToggle == "Day",
                    presentCount: presentCount,
                    absentCount: absentCount,
                    onToggle: selectedToggle == "Day"
                        ? (newValue) => setState(() => attendanceData["Day"]?[index] = newValue ? 1 : 0)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double scaleFactor) {
    if (selectedToggle == "Day") {
      return Column(children: [
        Text("Present: ${_getTotalPresent()}",
            style: TextStyle(fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
        Text("Absent: ${50 - _getTotalPresent()}",
            style: TextStyle(fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
      ]);
    } else {
      return Column(children: [
        Text(DateFormat("MMMM yyyy").format(DateTime.now()),
            style: TextStyle(fontSize: 18 * scaleFactor, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("Total Students: 50",
            style: TextStyle(fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
      ]);
    }
  }

  Widget _buildAttendanceLegend(double scaleFactor) {
    if (selectedToggle == "Day") return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(top: 8.0 * scaleFactor),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("P", style: TextStyle(color: Colors.blue, fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
        SizedBox(width: 5 * scaleFactor),
        Container(height: 20 * scaleFactor, width: 1, color: Colors.blue),
        SizedBox(width: 5 * scaleFactor),
        Text("A", style: TextStyle(color: Colors.red, fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  int _getTotalPresent() {
    return attendanceData[selectedToggle]?.values.fold<int>(0, (sum, val) => sum + (val ?? 0)) ?? 0;
  }
}
