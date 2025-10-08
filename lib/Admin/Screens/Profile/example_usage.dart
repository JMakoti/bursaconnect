import 'package:flutter/material.dart';

import 'settings_page.dart';

// Example of how to use the new structure in your app
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Profile Demo',
      theme: ThemeData.dark(),
      home: const SettingsPage(), // This is your main settings screen
      debugShowCheckedModeBanner: false,
    );
  }
}

// Example of how to navigate to settings from another screen
class ExampleNavigationScreen extends StatelessWidget {
  const ExampleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          child: const Text('Go to Settings'),
        ),
      ),
    );
  }
}
