import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class AssessmentScreen extends StatelessWidget {
  final String subject;
  final String teacher;

  const AssessmentScreen({super.key, required this.subject, required this.teacher});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButtonWidget(),
                Text("Assessment", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),

                // 🔹 Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Standard : 5th", style: TextStyle(fontSize: 16.sp)),
                        Text("Division: A", style: TextStyle(fontSize: 16.sp)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total Students: 50", style: TextStyle(fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        Text("Teacher: $teacher", style: TextStyle(fontSize: 16.sp)),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weekday,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.blue, thickness: 1.h),

                // 🔹 Subject and Chapter
                Center(child: Text(subject, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chapter:", style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: 150.w,
                      height: 30.h,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp),
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                          border: OutlineInputBorder(),
                          hintText: "Chapter 2",
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.blue, thickness: 1.h),
                SizedBox(height: 20.h),

                // 🔹 Classwork Section
                Text("Classwork:", style: TextStyle(fontSize: 16.sp)),
                Container(
                  height: 130.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Completed exercises 1 to 5 from Chapter 2",
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 20.h),

                // 🔹 Class Activity Section
                Row(
                  children: [
                    Text("Class Activity:", style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Group discussion on story theme",
                        ),
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      onPressed: () {
                        // Handle "View" button click
                      },
                      child: Text("View", style: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // 🔹 Homework Section
                Text("Homework:", style: TextStyle(fontSize: 16.sp)),
                Container(
                  height: 130.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a summary of Chapter 2",
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 40.h), // Extra space at bottom for better scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }
}
