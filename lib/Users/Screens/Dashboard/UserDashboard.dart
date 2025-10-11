import '../../../core/colors/colors.dart';
import 'package:flutter/material.dart';
import '../Explore/bursary_listing.dart';
import '../../Screens/Activity/applied_bursary_listing.dart';
import '../Profile/profile.dart';
import '../../Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  AppUser? appUser;

  // final Map<String, dynamic> _studentInfo = {
  //   'name': 'John Kimani',
  //   'studentId': 'STU2024/001234',
  //   'institution': 'University of Nairobi',
  //   'course': 'Bachelor of Science in Computer Science',
  //   'year': '3rd Year',
  //   'email': 'john.kimani@student.uonbi.ac.ke',
  // };

  // final Map<String, dynamic> _bursaryStatus = {
  //   'status': 'Approved',
  //   'amount': 85000,
  //   'semester': 'Semester 2, 2024/2025',
  //   'disbursementDate': 'Nov 15, 2024',
  //   'remainingBalance': 42500,
  // };

  // final List<Map<String, dynamic>> _documents = [
  //   {
  //     'name': 'Bursary Award Letter',
  //     'date': 'Sept 10, 2024',
  //     'size': '2.4 MB',
  //     'icon': Icons.description,
  //   },
  //   {
  //     'name': 'Fee Statement',
  //     'date': 'Oct 01, 2024',
  //     'size': '1.8 MB',
  //     'icon': Icons.receipt_long,
  //   },
  //   {
  //     'name': 'Application Form',
  //     'date': 'Aug 20, 2024',
  //     'size': '3.1 MB',
  //     'icon': Icons.assignment,
  //   },
  // ];

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

  @override
  Widget build(BuildContext context) {
    if (appUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(body: _buildBody(), bottomNavigationBar: _buildBottomNav());
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return BursaryListing();
      case 2:
        return AppliedBursaryListing();
      default:
        return Profile();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          // _buildBursaryStatusCard(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 20),
          // _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final name = appUser?.fullname ?? 'Student';
    final email = appUser?.email ?? 'student@gmail.com';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(color: AppColors.background, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            name.split(' ')[0],
            style: const TextStyle(
              color: AppColors.background,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.email, color: AppColors.background, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 8),
          // Row(
          //   children: [
          //     const Icon(Icons.book, color: AppColors.background, size: 18),
          //     const SizedBox(width: 8),
          //     Expanded(
          //       child: Text(
          //         '${_studentInfo['course']} • ${_studentInfo['year']}',
          //         style: const TextStyle(
          //           color: AppColors.background,
          //           fontSize: 13,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  // Widget _buildBursaryStatusCard() {
  //   final status = _bursaryStatus['status'];
  //   final statusColor = status == 'Approved'
  //       ? AppColors.success
  //       : status == 'Pending'
  //       ? AppColors.secondaryText
  //       : AppColors.error;

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
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text(
  //               'Bursary Status',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 12,
  //                 vertical: 6,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: statusColor.withValues(alpha: 0.1),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.check_circle, color: statusColor, size: 16),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     status,
  //                     style: TextStyle(
  //                       color: statusColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildInfoColumn(
  //                 'Total Award',
  //                 'KES ${_bursaryStatus['amount'].toStringAsFixed(0)}',
  //                 Icons.account_balance_wallet,
  //               ),
  //             ),
  //             Container(
  //               height: 50,
  //               width: 1,
  //               color: AppColors.secondaryText.withValues(alpha: 0.3),
  //             ),
  //             Expanded(
  //               child: _buildInfoColumn(
  //                 'Balance',
  //                 'KES ${_bursaryStatus['remainingBalance'].toStringAsFixed(0)}',
  //                 Icons.savings,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         const Divider(),
  //         const SizedBox(height: 16),
  //         _buildInfoRow(
  //           Icons.calendar_today,
  //           'Semester',
  //           _bursaryStatus['semester'],
  //         ),
  //         const SizedBox(height: 12),
  //         _buildInfoRow(
  //           Icons.payment,
  //           'Next Disbursement',
  //           _bursaryStatus['disbursementDate'],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildInfoColumn(String label, String value, IconData icon) {
  //   return Column(
  //     children: [
  //       Icon(icon, color: AppColors.primary, size: 28),
  //       const SizedBox(height: 8),
  //       Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
  //       const SizedBox(height: 4),
  //       Text(
  //         value,
  //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildInfoRow(IconData icon, String label, String value) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 20, color: AppColors.secondaryText),
  //       const SizedBox(width: 12),
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
  //       ),
  //       const Spacer(),
  //       Text(
  //         value,
  //         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Apply for Bursary',
                icon: Icons.add_circle_outline,
                color: AppColors.secondaryText,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BursaryListing()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'View Documents',
                icon: Icons.folder_open,
                color: AppColors.error,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BursaryListing()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Download Receipt',
                icon: Icons.download,
                color: AppColors.success,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BursaryListing()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Contact Support',
                icon: Icons.support_agent,
                color: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BursaryListing()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryText.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDocumentsTab() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'My Documents',
  //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 16),
  //         ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: _documents.length,
  //           itemBuilder: (context, index) {
  //             final doc = _documents[index];
  //             return Container(
  //               margin: const EdgeInsets.only(bottom: 12),
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: AppColors.background,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: AppColors.secondaryText.withValues(alpha: 0.5),
  //                     blurRadius: 10,
  //                     offset: const Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: AppColors.accent.withValues(alpha: 0.1),
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Icon(doc['icon'], color: AppColors.primary),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           doc['name'],
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 15,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           '${doc['date']} • ${doc['size']}',
  //                           style: TextStyle(
  //                             fontSize: 13,
  //                             color: AppColors.secondaryText,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(Icons.download),
  //                     color: AppColors.primary,
  //                     onPressed: () {},
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProfileTab() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         const CircleAvatar(
  //           radius: 50,
  //           backgroundColor: AppColors.primary,
  //           child: Icon(Icons.person, size: 50, color: AppColors.background),
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           _studentInfo['name'],
  //           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           _studentInfo['studentId'],
  //           style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
  //         ),
  //         const SizedBox(height: 24),
  //         _buildProfileCard(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildProfileCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: AppColors.background,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.secondaryText,
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         _buildProfileRow(
  //           Icons.school,
  //           'Institution',
  //           _studentInfo['institution'],
  //         ),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.book, 'Course', _studentInfo['course']),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.grade, 'Year', _studentInfo['year']),
  //         const Divider(height: 24),
  //         _buildProfileRow(Icons.email, 'Email', _studentInfo['email']),

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
  //             Text(
  //               label,
  //               style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               value,
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondaryText,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Activities'),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Profile',
        ),
      ],
    );
  }
}
