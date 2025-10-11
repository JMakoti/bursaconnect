import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/colors/colors.dart';
// import '../../Data/mock_student.dart';
// import '../../Models/student.dart';
import '../../Models/user_model.dart';
// import './edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // late Student student;
  AppUser? appUser;

  @override
  void initState() {
    super.initState();
    // student = mockStudent;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          setState(() {
            appUser = AppUser.fromJson(data, user.uid);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  // void _openEditStepper() async {
  //   final updated = await Navigator.push<Student?>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => EditStudentStepperPage(initialStudent: student),
  //     ),
  //   );

  //   if (updated != null) {
  //     setState(() => student = updated);
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Student updated')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (appUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = appUser!.fullname;
    final email = appUser!.email;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.background),
            // onPressed: _openEditStepper,
            onPressed: (){},
          ),
        ],
      ),
      body: _buildProfileTab(name, email),
    );
  }

  Widget _buildProfileTab(String name, String email) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 50, color: AppColors.background),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          // _buildProfileCard(),
        ],
      ),
    );
  }

  // Widget _buildProfileCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: AppColors.background,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.secondaryText.withValues(alpha: 0.3),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         _buildProfileRow(Icons.school, 'Institution', student.educationInfo.institution),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.book, 'Course', student.educationInfo.course),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.grade, 'Year', student.educationInfo.year),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.person, 'Guardian', student.guardianName ?? 'N/A'),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.phone, 'Guardian Phone', student.guardianPhone ?? 'N/A'),
  //         const Divider(height: 24),
  //         _buildDocumentsTab(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProfileRow(IconData icon, String label, String value) {
  //   return Row(
  //     children: [
  //       Icon(icon, color: AppColors.primary),
  //       const SizedBox(width: 16),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(label,
  //                 style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
  //             const SizedBox(height: 4),
  //             Text(value,
  //                 style: const TextStyle(
  //                     fontSize: 15, fontWeight: FontWeight.w600)),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDocumentsTab() {
  //   final docs = student.attachments;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'My Documents',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 12),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: docs.length,
  //         itemBuilder: (context, index) {
  //           final doc = docs[index];
  //           return Container(
  //             margin: const EdgeInsets.only(bottom: 12),
  //             padding: const EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: AppColors.background,
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: AppColors.secondaryText.withValues(alpha: 0.2),
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: AppColors.accent.withValues(alpha: 0.1),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Icon(doc.icon, color: AppColors.primary),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Text(
  //                     doc.name,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.download),
  //                   color: AppColors.primary,
  //                   onPressed: () {
  //                     // TODO: implement download
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }
}
