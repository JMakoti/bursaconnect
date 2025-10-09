
/// ------------------------------------------------------------------
/// EditStudentStepperPage
/// Full-screen page with a Stepper that edits the Student object and
/// returns the updated Student via Navigator.pop(updatedStudent).
/// ------------------------------------------------------------------
import 'package:flutter/material.dart';
import '../../../core/colors/colors.dart';
// import '../../Data/mock_student.dart'; 
import '../../Models/student.dart'; 

class EditStudentStepperPage extends StatefulWidget {
  final Student initialStudent;
  const EditStudentStepperPage({super.key, required this.initialStudent});

  @override
  State<EditStudentStepperPage> createState() => _EditStudentStepperPageState();
}

class _EditStudentStepperPageState extends State<EditStudentStepperPage> {
  final _formKeys = List.generate(6, (_) => GlobalKey<FormState>());
  int _currentStep = 0;

  // controllers for personal
  late TextEditingController _nameCtrl;
  late TextEditingController _studentIdCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _idNumberCtrl;

  // controllers for academic
  late TextEditingController _institutionCtrl;
  late TextEditingController _levelCtrl;
  late TextEditingController _yearCtrl;
  late TextEditingController _courseCtrl;
  late TextEditingController _courseDurationCtrl;
  late TextEditingController _modeCtrl;

  // next of kin
  late TextEditingController _guardianNameCtrl;
  late TextEditingController _guardianPhoneCtrl;

  // bursary
  late TextEditingController _amountRequestedCtrl;
  late TextEditingController _amountReceivedCtrl;
  String _bursaryStatus = 'Pending';

  // attachments: work on a mutable copy
  late List<Attachment> _attachments;

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;

    _nameCtrl = TextEditingController(text: s.fullName);
    _studentIdCtrl = TextEditingController(text: s.studentId);
    _emailCtrl = TextEditingController(text: s.email);
    _idNumberCtrl = TextEditingController(text: s.idNumber);

    final edu = s.educationInfo;
    _institutionCtrl = TextEditingController(text: edu.institution);
    _levelCtrl = TextEditingController(text: edu.level);
    _yearCtrl = TextEditingController(text: edu.year);
    _courseCtrl = TextEditingController(text: edu.course);
    _courseDurationCtrl = TextEditingController(text: edu.courseDuration);
    _modeCtrl = TextEditingController(text: edu.modeOfStudy);

    _guardianNameCtrl = TextEditingController(text: s.educationInfo == null ? '' : s.fullName); // fallback (if you have guardian fields in Student add them)
    // If your Student model has guardian fields, replace the above with correct fields.
    // For this code base, we didn't store guardian in Student; if you do, wire it here.
    _guardianNameCtrl = TextEditingController(text: (s is dynamic && (s.guardianName ?? '') != '' ) ? s.guardianName ?? '' : '');
    _guardianPhoneCtrl = TextEditingController(text: (s is dynamic && (s.guardianPhone ?? '') != '' ) ? s.guardianPhone ?? '' : '');

    final b = s.bursaryInfo;
    _amountRequestedCtrl = TextEditingController(text: b.amountRequested.toStringAsFixed(0));
    _amountReceivedCtrl = TextEditingController(text: b.amountReceived.toStringAsFixed(0));
    _bursaryStatus = b.status;

    _attachments = List.from(s.attachments);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _studentIdCtrl.dispose();
    _emailCtrl.dispose();
    _idNumberCtrl.dispose();
    _institutionCtrl.dispose();
    _levelCtrl.dispose();
    _yearCtrl.dispose();
    _courseCtrl.dispose();
    _courseDurationCtrl.dispose();
    _modeCtrl.dispose();
    _guardianNameCtrl.dispose();
    _guardianPhoneCtrl.dispose();
    _amountRequestedCtrl.dispose();
    _amountReceivedCtrl.dispose();
    super.dispose();
  }

  Color _statusToColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orangeAccent;
    }
  }

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
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'File name')),
            TextField(controller: fileTypeCtrl, decoration: const InputDecoration(labelText: 'File type (e.g. PDF, Image)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _attachments.add(Attachment(name: nameCtrl.text.trim(), icon: Icons.insert_drive_file, fileType: fileTypeCtrl.text.trim().isEmpty ? 'File' : fileTypeCtrl.text.trim()));
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

  void _saveAndReturn() {
    // build updated nested models and student
    final updatedEdu = widget.initialStudent.educationInfo.copyWith(
      institution: _institutionCtrl.text.trim(),
      level: _levelCtrl.text.trim(),
      year: _yearCtrl.text.trim(),
      course: _courseCtrl.text.trim(),
      courseDuration: _courseDurationCtrl.text.trim(),
      modeOfStudy: _modeCtrl.text.trim(),
    );

    final updatedBursary = widget.initialStudent.bursaryInfo.copyWith(
      amountRequested: double.tryParse(_amountRequestedCtrl.text.trim()) ?? widget.initialStudent.bursaryInfo.amountRequested,
      amountReceived: double.tryParse(_amountReceivedCtrl.text.trim()) ?? widget.initialStudent.bursaryInfo.amountReceived,
      status: _bursaryStatus,
      statusColor: _statusToColor(_bursaryStatus),
    );

    // If your Student model keeps guardian fields, adjust below accordingly.
    // Building the new student from the available fields:
    final updatedStudent = widget.initialStudent.copyWith(
      fullName: _nameCtrl.text.trim(),
      studentId: _studentIdCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      idNumber: _idNumberCtrl.text.trim(),
      educationInfo: updatedEdu,
      bursaryInfo: updatedBursary,
      attachments: _attachments,
    );

    Navigator.pop(context, updatedStudent);
  }

  List<Step> _steps() => [
        Step(
          title: const Text('Personal'),
          content: Form(
            key: _formKeys[0],
            child: Column(
              children: [
                TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _studentIdCtrl, decoration: const InputDecoration(labelText: 'Student ID'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _idNumberCtrl, decoration: const InputDecoration(labelText: 'ID Number')),
              ],
            ),
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Academic'),
          content: Form(
            key: _formKeys[1],
            child: Column(
              children: [
                TextFormField(controller: _institutionCtrl, decoration: const InputDecoration(labelText: 'Institution'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _courseCtrl, decoration: const InputDecoration(labelText: 'Course')),
                const SizedBox(height: 8),
                TextFormField(controller: _yearCtrl, decoration: const InputDecoration(labelText: 'Year')),
                const SizedBox(height: 8),
                TextFormField(controller: _courseDurationCtrl, decoration: const InputDecoration(labelText: 'Course Duration')),
                const SizedBox(height: 8),
                TextFormField(controller: _modeCtrl, decoration: const InputDecoration(labelText: 'Mode of Study')),
              ],
            ),
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Next of Kin'),
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: _addAttachmentDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add attachment'),
                ),
                const SizedBox(height: 8),
                if (_attachments.isEmpty) const Text('No attachments yet'),
                ListView.separated(
                  shrinkWrap: true,
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
                )
              ],
            ),
          ),
          isActive: _currentStep >= 4,
          state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        ),

        Step(
          title: const Text('Review & Save'),
          content: Form(
            key: _formKeys[5],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Review changes below', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Name: ${_nameCtrl.text}'),
                Text('Student ID: ${_studentIdCtrl.text}'),
                Text('Email: ${_emailCtrl.text}'),
                const SizedBox(height: 8),
                Text('Institution: ${_institutionCtrl.text}'),
                Text('Course: ${_courseCtrl.text}'),
                const SizedBox(height: 8),
                Text('Amount requested: ${_amountRequestedCtrl.text}'),
                Text('Status: $_bursaryStatus'),
                const SizedBox(height: 8),
                const Text('Attachments:', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._attachments.map((a) => Text('- ${a.name} (${a.fileType})')).toList(),
              ],
            ),
          ),
          isActive: _currentStep >= 5,
          state: _currentStep > 5 ? StepState.complete : StepState.indexed,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: AppColors.primary,
      ),
      body: Stepper(
        type: StepperType.vertical,
        physics: const ClampingScrollPhysics(),
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: _steps(),
        controlsBuilder: (context, details) {
          final isLast = _currentStep == _steps().length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: details.onStepContinue,
                  child: Text(isLast ? 'Save' : 'Next'),
                ),
                const SizedBox(width: 12),
                TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
              ],
            ),
          );
        },
      ),
    );
  }
}

