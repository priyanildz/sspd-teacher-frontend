import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ViewTestRecord extends StatefulWidget {
  const ViewTestRecord({super.key});

  @override
  _ViewTestRecordState createState() => _ViewTestRecordState();
}

class _ViewTestRecordState extends State<ViewTestRecord> {
  List<String> studentNames = [
    "Students Name", "Students Name", "Students Name",
    "Students Name", "Students Name", "Students Name",
    "Students Name", "Students Name"
  ];
  List<String> rollNumbers = ["01", "02", "03", "04", "05", "06", "07", "08"];
  List<String> scores = ["45", "40", "42", "38", "NA", "42", "43", "NA"];
  List<String> alphabets = ["A", "B", "C", "D", "E", "F", "G", "H"];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(scores.length, (index) {
      return TextEditingController(text: scores[index] == "NA" ? "" : scores[index]);
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Header Information**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BackButtonWidget(),
                    Text(
                      "Test Record",
                      style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.only(top: screenHeight * 0.01)),
                    Text("Total Students: 50", style: TextStyle(fontSize: screenWidth * 0.04)),
                    Text("Total Marks: 50", style: TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            Text("30 January 2025", style: TextStyle(fontSize: screenWidth * 0.04)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Wednesday", style: TextStyle(fontSize: screenWidth * 0.04)),
                Text("Teacher: Miss Sharma", style: TextStyle(fontSize: screenWidth * 0.04)),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(formattedDate, style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                        Text(weekday, style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("S-40", style: TextStyle(fontSize: screenWidth * 0.035)),
                    Text("N-10", style: TextStyle(fontSize: screenWidth * 0.035)),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),

            // **Subject & Chapter Row**
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(color: Colors.blue)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("English Test", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                  Text("Chapter: 2 - A Moon in the Sky", style: TextStyle(fontSize: screenWidth * 0.04)),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),

            // **Search Bar**
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Student",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(Icons.search, color: Colors.blue, size: screenWidth * 0.08),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),

            // **Student List**
            Expanded(
              child: ListView.builder(
                itemCount: studentNames.length,
                itemBuilder: (context, index) {
                  return _buildStudentItem(index, screenWidth, screenHeight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **Student List Item Widget**
  Widget _buildStudentItem(int index, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      child: Row(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.05,
            backgroundColor: Colors.blue,
            child: Text(
              alphabets[index],
              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentNames[index], style: TextStyle(fontSize: screenWidth * 0.04)),
                Text("Roll no: ${rollNumbers[index]}", style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey)),
              ],
            ),
          ),

          // **Editable Marks Field**
          SizedBox(
            width: screenWidth * 0.2,
            child: TextField(
              controller: controllers[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              ),
              onChanged: (value) {
                setState(() {
                  scores[index] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
