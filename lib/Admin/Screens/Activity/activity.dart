import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {"title": "John applied for County Bursary 2025", "time": "2 hrs ago"},
      {"title": "Admin posted Equity Wings to Fly Bursary", "time": "Yesterday"},
      {"title": "Mary’s application was approved", "time": "2 days ago"},
      {"title": "Eligibility updated for National Gov Bursary", "time": "3 days ago"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Log"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: const Icon(Icons.history, color: Colors.indigo),
            title: Text(activity["title"] ?? ""),
            subtitle: Text(activity["time"] ?? ""),
          );
        },
      ),
    );
  }
}
