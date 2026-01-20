import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/login_screen.dart';
import 'package:teacher_portal/screens/home_screen.dart';
import 'package:teacher_portal/screens/profile/profile_screen.dart';
import 'package:teacher_portal/screens/notification_screen.dart';
import 'package:teacher_portal/screens/myschedule_screen.dart';
import 'package:teacher_portal/screens/messages_screen.dart';
import 'package:teacher_portal/screens/profile/my_profile_screen.dart';
import 'package:teacher_portal/screens/profile/my_attendance_screen.dart';
import 'package:teacher_portal/screens/profile/leave_request.dart';
import 'package:teacher_portal/screens/profile/subject_class_screen.dart';
import 'package:teacher_portal/screens/attendance_screen.dart';
import 'package:teacher_portal/screens/monthly_attendance_screen.dart';
import 'package:teacher_portal/screens/timetable_screen.dart';
import 'package:teacher_portal/screens/assessment_screen.dart';
import 'package:teacher_portal/screens/test_record_screen.dart';
import 'package:teacher_portal/screens/lecture_test_record.dart';
import 'package:teacher_portal/screens/view_test_record.dart';
import 'package:teacher_portal/screens/fees_record.dart';
import 'package:teacher_portal/screens/class_report_screen.dart';
import 'package:teacher_portal/screens/syllabus_tracker.dart';
import 'package:teacher_portal/screens/announcement_screen.dart';
import 'package:teacher_portal/screens/event_screen.dart';
import 'package:teacher_portal/screens/exam_screen.dart';
import 'package:teacher_portal/screens/exam_timetable_screen.dart';
import 'package:teacher_portal/screens/exam_attendance_screen.dart';



import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen()); // ❌ Removed const
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case AppRoutes.mySchedule:
        return MaterialPageRoute(builder: (_) =>  MyScheduleScreen());
      case AppRoutes.messages:
        return MaterialPageRoute(builder: (_) =>  MessagesScreen());
      case AppRoutes.myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfileScreen()); // ✅ Add MyProfileScreen route
      case AppRoutes.myAttendance:
        return MaterialPageRoute(builder: (_) => const MyAttendanceScreen());
      case AppRoutes.leaveRequest:
        return MaterialPageRoute(builder: (_) => const LeaveRequest());
      case AppRoutes.subjectClass:
        return MaterialPageRoute(builder: (_) => const SubjectClassScreen());
       case AppRoutes.attendance:
         return MaterialPageRoute(builder: (_) => const AttendanceScreen());
        case AppRoutes.monthlyAttendance:
          return MaterialPageRoute(builder: (_) => const MonthlyAttendanceScreen());

      case AppRoutes.timeTable:
        return MaterialPageRoute(builder: (_) => const TimetableScreen());

      case AppRoutes.examTimetable: // Ensure this exists in your app_routes.dart file
  return MaterialPageRoute(builder: (_) => const ExamTimetableScreen());

      case AppRoutes.assessment:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return AssessmentScreen(
              subject: args['subject'] ?? 'Unknown Subject',
              teacher: args['teacher'] ?? 'Unknown Teacher',
            );
          },
// No arguments passed directly
        );




      case AppRoutes.testRecord:
        return MaterialPageRoute(builder: (_) => const TestRecordScreen());

        case AppRoutes.viewTestRecord:
        return MaterialPageRoute(builder: (_) => const ViewTestRecord());

        case AppRoutes.lectureTestRecord:
        return MaterialPageRoute(builder: (_) => const LectureTestRecord());

        case AppRoutes.feesRecord:
        return MaterialPageRoute(builder: (_) => const FeesRecord());

        case AppRoutes.classReport:
        return MaterialPageRoute(builder: (_) => const ClassReportScreen());

        case AppRoutes.syllabusTracker:
        return MaterialPageRoute(builder: (_) =>  SyllabusTrackerScreen());

        case AppRoutes.announcement:
        return MaterialPageRoute(builder: (_) =>  AnnouncementScreen());

        case AppRoutes.event:
          return MaterialPageRoute(builder: (_) =>  EventsScreen());

          case AppRoutes.exam:
          return MaterialPageRoute(builder: (_) =>  ExamScreen());

      case AppRoutes.examAttendance:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ExamAttendanceScreen(subject: args['subject']),
        );












      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Page Not Found")),
            body: const Center(child: Text("404 Page Not Found")),
          ),
        );
    }
  }
}
