import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/add_button.dart';
import 'package:teacher_portal/screens/home_screen.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class TestRecordScreen extends StatelessWidget {
  const TestRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Get Current Date
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return WillPopScope(
      onWillPop: () async {
        // Navigate to Home Screen when back is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return false; // ✅ Fixed syntax error (removed extra `/`)
      },
      child: MainLayout(
        selectedIndex: 0,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding based on screen size
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // **Header Section**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(),
                    Text(
                      "Test Record",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weekday,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // **Student Info Section**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Standard : 5th", style: TextStyle(fontSize: screenWidth * 0.04)),
                        Text("Division: A", style: TextStyle(fontSize: screenWidth * 0.04)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20, // Responsive circle avatar size
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.06),
                        onPressed: () => _showAddTestSheet(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Students: 50",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Class Teacher: Miss Sharma", style: TextStyle(fontSize: screenWidth * 0.04)),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(screenWidth * 0.15, screenHeight * 0.04),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Class",
                            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            minimumSize: Size(screenWidth * 0.15, screenHeight * 0.04),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/lecture-test-record");
                          },
                          child: Text(
                            "Lecture",
                            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),

                // **Search Bar & Filter Icons**
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Tests",
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

                // **Test Record List**
                _buildTestRecordItem(
                  context: context,
                  index: 1,
                  date: "30-01-2025",
                  day: "Wednesday",
                  subject: "English",
                  chapter: "2",
                  teacher: "Miss Sharma",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,

                ),
                _buildTestRecordItem(
                  context: context,
                  index: 2,
                  date: "29-01-2025",
                  day: "Wednesday",
                  subject: "Maths",
                  chapter: "1",
                  teacher: "Mr. Mishra",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                _buildTestRecordItem(
                  context: context,
                  index: 3,
                  date: "27-01-2025",
                  day: "Wednesday",
                  subject: "Science",
                  chapter: "1",
                  teacher: "Mr. Mishra",
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddTestBottomSheet(),
    );
  }

  // **Test Record Item Widget**
  Widget _buildTestRecordItem({
    required BuildContext context,
    required int index,
    required String date,
    required String day,
    required String subject,
    required String chapter,
    required String teacher,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02), // Responsive bottom margin
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Index Number with Full Height
            Container(
              width: screenWidth * 0.1, // Adjust width based on screen size
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Expanded Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // **Date & Teacher Row (Aligned)**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$date  $day",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: Text(
                          teacher,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // **Subject & Chapter Row (Aligned)**
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject & Chapter
                      Text(
                        "S-40  $subject  Chp: $chapter",
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "N-10 (Total Marks-50)",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/view-test-record');
                            },
                            child: const Text(
                              "View test record",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
