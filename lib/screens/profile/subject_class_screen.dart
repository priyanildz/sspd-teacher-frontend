import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/services/api_service.dart';
import 'package:teacher_portal/services/auth_service.dart';

class SubjectClassScreen extends StatefulWidget {
  const SubjectClassScreen({super.key});

  @override
  _SubjectClassScreenState createState() => _SubjectClassScreenState();
}

class _SubjectClassScreenState extends State<SubjectClassScreen> {
  List<dynamic> subjects = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    String? userId = await AuthService.getUserId();

    if (userId == null) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to get user ID";
      });
      return;
    }

    var response = await ApiService.fetchMySubjects();
    print("🔥 API Response: $response");

    if (response["success"]) {
      List<dynamic> subjectData = response["subjects"] ?? [];

      setState(() {
        subjects = subjectData.isNotEmpty ? (subjectData[0]["subjects"] ?? []) : [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = response['message'] ?? "Failed to fetch subjects";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MainLayout(
      selectedIndex: 0,
      child: RefreshIndicator(
        onRefresh: fetchSubjects,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: Text(
                  "My Subject & Class",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              else if (subjects.isEmpty)
                  Center(
                    child: Text(
                      "No subjects assigned yet.",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  )
                else
                  Expanded(
                      child: SizedBox(
                        width: screenWidth * 0.95, // More compact width
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 60, // More compact
                            headingRowHeight: 40, // Smaller heading row
                            dataRowHeight: 40, // Smaller data rows
                            headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue[100]!,
                            ),
                            border: TableBorder.all(
                              color: Colors.blue,
                              width: 1.2, // Thinner border
                            ),
                            columns: [
                              DataColumn(
                                label: Text(
                                  "Subject",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Standard",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Division",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                            rows: subjects.map((subject) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(subject["subject_name"] ?? "Unknown",
                                      style: TextStyle(fontSize: 14))),
                                  DataCell(Text(subject["standard"] ?? "N/A",
                                      style: TextStyle(fontSize: 14))),
                                  DataCell(Text(subject["division"] ?? "-",
                                      style: TextStyle(fontSize: 14))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
