import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacher_portal/routes/app_routes.dart';
import 'package:teacher_portal/routes/app_router.dart';
import 'package:teacher_portal/services/socket_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService.initialize(); // ✅ Initialize WebSocket globally
  runApp(const TeacherPortalApp());
}

class TeacherPortalApp extends StatelessWidget {
  const TeacherPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjust this based on your base design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Teacher Portal',
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
