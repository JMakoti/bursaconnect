import 'package:flutter/material.dart';
import 'package:bursaconnect/Users/widgets/dashboardCard.dart';
import 'package:bursaconnect/Admin/Screens/Bursary/post_bursary_screen.dart';
import 'package:bursaconnect/Admin/Screens/Student/ReviewApplications.dart';
import 'package:bursaconnect/Admin/Screens/Activity/activity.dart';

class AdminDash extends StatelessWidget {
  const AdminDash({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A8A);
    const Color lightBackground = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.menu_rounded, color: Colors.white),
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityScreen()),
              );
            },
          ),
        ],
      ),

      // Body with vertical cards
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            DashboardCard(
              title: "Total Applicants",
              value: "124",
              icon: Icons.people_alt_rounded,
              color: Color(0xFF2563EB),
            ),
            SizedBox(height: 20),
            DashboardCard(
              title: "Active Bursaries",
              value: "12",
              icon: Icons.school_rounded,
              color: Color(0xFF059669),
            ),
            SizedBox(height: 20),
            DashboardCard(
              title: "Approved Applications",
              value: "98",
              icon: Icons.check_circle_rounded,
              color: Color(0xFFF59E0B),
            ),
          ],
        ),
      ),

      // Bottom floating buttons row
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Tooltip(
              message: "Home",
              child: FloatingActionButton(
                heroTag: "homeBtn",
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminDash()),
                  );
                },
                child: Icon(Icons.home_rounded, color: primaryColor),
              ),
            ),
            Tooltip(
              message: "Post New Bursary",
              child: FloatingActionButton(
                heroTag: "postBtn",
                backgroundColor: primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostBursaryScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            Tooltip(
              message: "Review Applications",
              child: FloatingActionButton(
                heroTag: "reviewBtn",
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Reviewapplications(),
                    ),
                  );
                },
                child: Icon(Icons.rate_review_rounded, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
