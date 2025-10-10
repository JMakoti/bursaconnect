import 'package:flutter/material.dart';
import '../../../core/colors/colors.dart';
import '../../Models/student.dart';
import '../../Services/profile_service.dart'; 

class EditStudentStepperPage extends StatefulWidget {
  final Student initialStudent;
  const EditStudentStepperPage({super.key, required this.initialStudent});

  @override
  State<EditStudentStepperPage> createState() => _EditStudentStepperPageState();
}

class _EditStudentStepperPageState extends State<EditStudentStepperPage> {
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  int _currentStep = 0;

  // Academic info controllers
  late TextEditingController _institutionCtrl;
  late TextEditingController _levelCtrl;
  late TextEditingController _yearCtrl;
  late TextEditingController _courseCtrl;
  late TextEditingController _courseDurationCtrl;
  late TextEditingController _modeCtrl;

  // Guardian info
  late TextEditingController _guardianNameCtrl;
  late TextEditingController _guardianPhoneCtrl;

  // Attachments
  late List<Attachment> _attachments;

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;

    // Preload academic fields
    final edu = s.educationInfo;
    _institutionCtrl = TextEditingController(text: edu.institution);
    _levelCtrl = TextEditingController(text: edu.level);
    _yearCtrl = TextEditingController(text: edu.year);
    _courseCtrl = TextEditingController(text: edu.course);
    _courseDurationCtrl = TextEditingController(text: edu.courseDuration);
    _modeCtrl = TextEditingController(text: edu.modeOfStudy);

    // Preload guardian
    _guardianNameCtrl = TextEditingController(text: s.guardianName ?? '');
    _guardianPhoneCtrl = TextEditingController(text: s.guardianPhone ?? '');

    // Preload attachments
    _attachments = List.from(s.attachments);
  }

  @override
  void dispose() {
    _institutionCtrl.dispose();
    _levelCtrl.dispose();
    _yearCtrl.dispose();
    _courseCtrl.dispose();
    _courseDurationCtrl.dispose();
    _modeCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
    super.dispose();
  }

  /// Add new attachment
  void _addAttachmentDialog() {
    final nameCtrl = TextEditingController();
    final fileTypeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Attachment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'File name (e.g. ID.pdf)')),
            TextField(
                controller: fileTypeCtrl,
                decoration:
                    const InputDecoration(labelText: 'File type (PDF, Image)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _attachments.add(Attachment(
                    name: nameCtrl.text.trim(),
                    icon: Icons.insert_drive_file,
                    fileType: fileTypeCtrl.text.trim().isEmpty
                        ? 'File'
                        : fileTypeCtrl.text.trim(),
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Handle step navigation
  void _onStepContinue() {
    final isLast = _currentStep == _steps().length - 1;
    final formOk = _formKeys[_currentStep].currentState?.validate() ?? true;

    if (!formOk) return;

    if (isLast) {
      _saveAndReturn();
    } else {
      setState(() => _currentStep += 1);
    }
  }

  void _onStepCancel() {
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _currentStep -= 1);
    }
  }

  /// Save and return updated student object
  // void _saveAndReturn() {
  //   final updatedEdu = widget.initialStudent.educationInfo.copyWith(
  //     institution: _institutionCtrl.text.trim(),
  //     level: _levelCtrl.text.trim(),
  //     year: _yearCtrl.text.trim(),
  //     course: _courseCtrl.text.trim(),
  //     courseDuration: _courseDurationCtrl.text.trim(),
  //     modeOfStudy: _modeCtrl.text.trim(),
  //   );

  //   final updatedStudent = Student(
  //     userId: widget.initialStudent.userId,
  //     bursaryId: widget.initialStudent.bursaryId,
  //     educationInfo: updatedEdu,
  //     attachments: _attachments,
  //     guardianName: _guardianNameCtrl.text.trim(),
  //     guardianPhone: _guardianPhoneCtrl.text.trim(),
  //   );

  //   Navigator.pop(context, updatedStudent);
  // }

void _saveAndReturn() async {
  final updatedEdu = widget.initialStudent.educationInfo.copyWith(
    institution: _institutionCtrl.text.trim(),
    level: _levelCtrl.text.trim(),
    year: _yearCtrl.text.trim(),
    course: _courseCtrl.text.trim(),
    courseDuration: _courseDurationCtrl.text.trim(),
    modeOfStudy: _modeCtrl.text.trim(),
  );

  final updatedStudent = Student(
    userId: widget.initialStudent.userId,
    bursaryId: widget.initialStudent.bursaryId,
    educationInfo: updatedEdu,
    attachments: _attachments,
    guardianName: _guardianNameCtrl.text.trim(),
    guardianPhone: _guardianPhoneCtrl.text.trim(),
  );

  try {
    final service = ProfileService();
    await service.updateStudentProfile(updatedStudent);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context, updatedStudent);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating profile: $e')),
    );
  }
}


  List<Step> _steps() => [
        Step(
          title: const Text('Academic Info'),
          content: Form(
            key: _formKeys[0],
            child: Column(
              children: [
                TextFormField(
                    controller: _institutionCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Institution'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _levelCtrl,
                    decoration: const InputDecoration(labelText: 'Level')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _yearCtrl,
                    decoration: const InputDecoration(labelText: 'Year')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _courseCtrl,
                    decoration: const InputDecoration(labelText: 'Course')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _courseDurationCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Course Duration')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _modeCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Mode of Study')),
              ],
            ),
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Guardian Info'),
          content: Form(
            key: _formKeys[1],
            child: Column(
              children: [
                TextFormField(
                    controller: _guardianNameCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Guardian Name')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _guardianPhoneCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Guardian Phone'),
                    keyboardType: TextInputType.phone),
              ],
            ),
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Attachments'),
          content: Form(
            key: _formKeys[2],
            child: Column(
              children: [
                TextFormField(controller: _guardianNameCtrl, decoration: const InputDecoration(labelText: 'Guardian name')),
                const SizedBox(height: 8),
                TextFormField(controller: _guardianPhoneCtrl, decoration: const InputDecoration(labelText: 'Guardian phone'), keyboardType: TextInputType.phone),
              ],
            ),
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Bursary'),
          content: Form(
            key: _formKeys[3],
            child: Column(
              children: [
                TextFormField(controller: _amountRequestedCtrl, decoration: const InputDecoration(labelText: 'Amount requested'), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                TextFormField(controller: _amountReceivedCtrl, decoration: const InputDecoration(labelText: 'Amount received'), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _bursaryStatus,
                  items: ['Pending', 'Approved', 'Rejected'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _bursaryStatus = v ?? 'Pending'),
                  decoration: const InputDecoration(labelText: 'Status'),
                )
              ],
            ),
          ),
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Attachments'),
          content: Form(
            key: _formKeys[4],
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: _addAttachmentDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add attachment'),
                ),
                const SizedBox(height: 12),
                if (_attachments.isEmpty)
                  const Text('No attachments yet.'),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _attachments.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final at = _attachments[i];
                    return ListTile(
                      leading: Icon(at.icon),
                      title: Text(at.name),
                      subtitle: Text(at.fileType),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => setState(() => _attachments.removeAt(i)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Review & Save'),
          content: Form(
            key: _formKeys[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Review your details:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Institution: ${_institutionCtrl.text}'),
                Text('Course: ${_courseCtrl.text}'),
                Text('Guardian: ${_guardianNameCtrl.text}'),
                const SizedBox(height: 8),
                Text('Amount requested: ${_amountRequestedCtrl.text}'),
                Text('Status: $_bursaryStatus'),
                const SizedBox(height: 8),
                const Text('Attachments:', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._attachments.map((a) => Text('- ${a.name} (${a.fileType})')).toList(),
              ],
            ),
          ),
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student Info'),
        backgroundColor: AppColors.primary,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (i) => setState(() => _currentStep = i),
        steps: _steps(),
        controlsBuilder: (context, details) {
          final isLast = _currentStep == _steps().length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: details.onStepContinue,
                  child: Text(isLast ? 'Save' : 'Next'),
                ),
                const SizedBox(width: 12),
                TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back')),
              ],
            ),
          );
        },
      ),
    );
  }
}
