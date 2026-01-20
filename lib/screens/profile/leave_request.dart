import 'package:flutter/material.dart';
import 'package:teacher_portal/widgets/custom_appBar.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/Card/leave_card.dart';
import 'package:teacher_portal/widgets/leave_request_form.dart';
import 'package:teacher_portal/screens/main_layout.dart';

class LeaveRequest extends StatelessWidget {
  const LeaveRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        selectedIndex: 0,
      child: Padding(
          padding:const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ProfileHeader(),
    
      SizedBox(height: 20),

    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
    "My Leave Request",
    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
    ),
    ElevatedButton(
    onPressed: (){
      _showLeaveRequestForm(context);
    },
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
    ),
    ),
    child: Text("Add"),
    )
    ],
    ),
    SizedBox(height: 20),

    Expanded(
    child: ListView.builder(
    itemCount: 3,
    itemBuilder: (context, index){
      return LeaveCard(index:index + 1);
    },
    )
    ),
    ],
    ),
      ),
    );
  }
}

void _showLeaveRequestForm(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: LeaveRequestForm(),
      );
    },
  );
}

