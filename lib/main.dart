import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Admin/Screens/Dashboard/adminDash.dart';
import 'firebase_options.dart';

//Providers
import 'package:bursaconnect/Admin/Providers/provider.dart';

// Screens
import 'package:bursaconnect/Authentication/login_screen.dart';
import 'package:bursaconnect/Admin/Screens/Dashboard/adminDash.dart';
import 'package:bursaconnect/Users/Screens/Dashboard/UserDashboard.dart';
import 'package:bursaconnect/Admin/Screens/Student/ReviewApplications.dart';
import 'package:bursaconnect/Admin/Screens/Student/ApprovedApplications.dart';
import 'package:bursaconnect/Admin/Screens/Activity/activity.dart';
import 'package:bursaconnect/Admin/Screens/Profile/profile_page.dart';
import 'package:bursaconnect/Admin/Screens/Profile/settings_page.dart';
import 'package:bursaconnect/Admin/Screens/Bursary/post_bursary_screen.dart';
import 'package:bursaconnect/Admin/Screens/Bursary/bursary.dart';
import 'package:bursaconnect/Admin/Screens/Bursary/BursaryDetails.dart';
import 'package:bursaconnect/Admin/Screens/Student/AcceptReject.dart';
import 'package:bursaconnect/Admin/Screens/Student/student.dart';
import 'package:bursaconnect/Admin/Screens/Student/StudentDetails.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:  (_) => BursaryNotifier()),
      ChangeNotifierProvider(create:(_) =>AllApplicants())
    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bursary App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/adminDashboard': (context) => AdminDash(),
        '/userDashboard': (context) => const UserDashboard(),

        // Admin routes
        '/postBursary': (context) => const PostBursaryScreen(),
        '/reviewApplications': (context) => const Reviewapplications(),
        '/approvedApplications': (context) => const Approvedapplications(),
        '/activity': (context) => const ActivityScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        "/bursary":(context)=>Bursary(),
        "/bursarydetail":(context)=>BursaryDetails(),
        "/acceptreject":(context)=>Acceptreject(),
        "/student":(context)=>Student(),
        "/studentdetails":(context)=>Studentdetails()
      },
    );
  }
}
