import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore import

class PostBursaryScreen extends StatefulWidget {
  const PostBursaryScreen({super.key});

  @override
  State<PostBursaryScreen> createState() => _PostBursaryScreenState();
}

class _PostBursaryScreenState extends State<PostBursaryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _targetGroupController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _fundingTypeController = TextEditingController();
  final TextEditingController _amountRangeController = TextEditingController();
  final TextEditingController _eligibilityController = TextEditingController();
  final TextEditingController _applicationModeController = TextEditingController();
  final TextEditingController _applicationPeriodController = TextEditingController();
  final TextEditingController _applicationLinkController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  bool _isOpen = true;

  Future<void> _saveBursary() async {
    try {
      // use bursary title as document ID (you can change to uuid if you want unique always)
      String docId = _titleController.text.trim();

      await FirebaseFirestore.instance.collection('bursaries').doc(docId).set({
        'title': _titleController.text.trim(),
        'provider': _providerController.text.trim(),
        'category': _categoryController.text.trim(),
        'type': _typeController.text.trim(),
        'targetGroup': _targetGroupController.text.trim(),
        'level': _levelController.text.trim(),
        'region': _regionController.text.trim(),
        'fundingType': _fundingTypeController.text.trim(),
        'amountRange': _amountRangeController.text.trim(),
        'eligibility': _eligibilityController.text.trim(),
        'applicationMode': _applicationModeController.text.trim(),
        'applicationPeriod': _applicationPeriodController.text.trim(),
        'applicationLink': _applicationLinkController.text.trim(),
        'deadline': _deadlineController.text.trim(),
        'contactEmail': _contactEmailController.text.trim(),
        'website': _websiteController.text.trim(),
        'isOpen': _isOpen,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Bursary submitted successfully")),
      );

      _formKey.currentState!.reset();
      setState(() {
        _isOpen = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to submit: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E3A8A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Post New Bursary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Bursary Title", _titleController),
              _buildTextField("Provider", _providerController),
              _buildTextField("Category", _categoryController),
              _buildTextField("Type", _typeController),
              _buildTextField("Target Group", _targetGroupController),
              _buildTextField("Level", _levelController),
              _buildTextField("Region", _regionController),
              _buildTextField("Funding Type", _fundingTypeController),
              _buildTextField("Amount Range", _amountRangeController),
              _buildTextField("Eligibility (comma-separated)", _eligibilityController, maxLines: 2),
              _buildTextField("Application Mode", _applicationModeController),
              _buildTextField("Application Period", _applicationPeriodController),
              _buildTextField("Application Link", _applicationLinkController),
              _buildTextField("Deadline", _deadlineController),
              _buildTextField("Contact Email", _contactEmailController),
              _buildTextField("Website", _websiteController),
              const SizedBox(height: 12),

              // Toggle open/closed
              SwitchListTile(
                value: _isOpen,
                activeColor: primaryColor,
                title: const Text("Is Open?"),
                onChanged: (val) {
                  setState(() {
                    _isOpen = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Full-width submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveBursary(); // ✅ Firestore save
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
