import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/student_fees_tile.dart';
import 'package:fl_chart/fl_chart.dart';// Import the student tile
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/services/auth_service.dart';

class FeesRecord extends StatefulWidget {
  const FeesRecord({super.key});

  @override
  _FeesRecordState createState() => _FeesRecordState();
}

class _FeesRecordState extends State<FeesRecord> {
  String selectedSem = "1"; // Default selected semester


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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    // Get screen width and height for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust font size and padding based on screen width
    double headerFontSize = screenWidth < 350 ? 14 : 20;
    double subHeaderFontSize = screenWidth < 350 ? 12 : 16;
    double dropdownFontSize = screenWidth < 350 ? 14 : 16;
    double searchBarHeight = screenWidth < 350 ? 40 : 50;
    double padding = screenWidth < 350 ? 8 : 12;

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(padding), // Dynamic padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Header Section**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text(
                  "Fees Record",
                  style: TextStyle(fontSize: headerFontSize, fontWeight: FontWeight.bold),
                ),
                Text("Total Students: 50", style: TextStyle(fontSize: subHeaderFontSize)),
              ],
            ),
            const SizedBox(height: 10),

            // **Standard & Division**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Standard: $standard", style: TextStyle(fontSize: subHeaderFontSize)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Division: $division", style: TextStyle(fontSize: subHeaderFontSize)),
                    _buildDropdown(dropdownFontSize), // ✅ Semester selection dropdown
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // **Date & Weekday Display**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **Date & Weekday in Center**
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: subHeaderFontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          weekday,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                // **Paid & Unpaid Summary (Aligned Right)**
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Paid: 48",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Unpaid: 02",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(thickness: 1, color: Colors.blue),

            // **Search Bar**
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Student",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // **Student Fees List**
            Expanded(
              child: ListView(
                children: [
                  StudentFeesTile(studentName: "Aman Kumar", rollNo: "01", totalFees: 5000, paidFees: 4000),
                  StudentFeesTile(studentName: "Bhavya Sharma", rollNo: "02", totalFees: 6000, paidFees: 3500),
                  StudentFeesTile(studentName: "Chetan Singh", rollNo: "03", totalFees: 4500, paidFees: 4500),
                  StudentFeesTile(studentName: "Divya Patel", rollNo: "04", totalFees: 7000, paidFees: 3000),
                  StudentFeesTile(studentName: "Esha Verma", rollNo: "05", totalFees: 8000, paidFees: 6000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ **Dropdown for Semester Selection**
  Widget _buildDropdown(double dropdownFontSize) {
    return DropdownButton<String>(
      value: selectedSem,
      onChanged: (String? newValue) {
        setState(() {
          selectedSem = newValue!;
        });
      },
      items: ["1", "2", "3", "4", "5"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text("Semester: $value", style: TextStyle(fontSize: dropdownFontSize)),
        );
      }).toList(),
    );
  }
}
