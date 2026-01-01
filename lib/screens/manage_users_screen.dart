import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/app_drawer.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FullFormScreen extends StatefulWidget {
  const FullFormScreen({super.key});

  @override
  State<FullFormScreen> createState() => _FullFormScreenState();
}

class _FullFormScreenState extends State<FullFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String? gender;
  String role = 'User';
  bool agree = false;
  bool notifications = true;
  double experience = 2;
  DateTime? dob;
  TimeOfDay? loginTime;

  final QuillController richTextCtrl = QuillController.basic();

  String status = 'Active';
  List<String> skills = [];
  final skillOptions = ['Flutter', 'React', 'Node', 'SQL', 'AWS'];

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    ageCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void cancelForm() {
    Navigator.pushReplacementNamed(context, '/users');
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept terms')),
      );
      return;
    }

    final data = {
      'name': nameCtrl.text,
      'email': emailCtrl.text,
      'age': ageCtrl.text,
      'gender': gender,
      'role': role,
      'experience': experience,
      'dob': dob?.toIso8601String(),
      'loginTime': loginTime?.format(context),
      'notifications': notifications,
      'skills': skills,
      'status': status,
    };

    debugPrint(data.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully')),
    );

    Navigator.pushReplacementNamed(context, '/');
  }

  Widget gridItem(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              int columns = 3;
              if (constraints.maxWidth < 900) columns = 2;
              if (constraints.maxWidth < 600) columns = 1;

              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 4.5,
                children: [
                  // NAME
                  gridItem(
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),

                  // EMAIL
                  gridItem(
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.contains('@') ? null : 'Invalid email',
                    ),
                  ),

                  // PASSWORD
                  gridItem(
                    TextFormField(
                      controller: passwordCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) =>
                          v!.length < 6 ? 'Min 6 chars' : null,
                    ),
                  ),

                  // AGE
                  gridItem(
                    TextFormField(
                      controller: ageCtrl,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // ROLE
                  gridItem(
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(
                            value: 'User', child: Text('User')),
                        DropdownMenuItem(
                            value: 'Admin', child: Text('Admin')),
                      ],
                      onChanged: (v) => setState(() => role = v!),
                    ),
                  ),

                  // STATUS
                  gridItem(
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(
                            value: 'Active', child: Text('Active')),
                        DropdownMenuItem(
                            value: 'Inactive', child: Text('Inactive')),
                        DropdownMenuItem(
                            value: 'Blocked', child: Text('Blocked')),
                      ],
                      onChanged: (v) => setState(() => status = v!),
                    ),
                  ),

                  // GENDER (FULL WIDTH)
                  GridTile(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender'),
                        RadioListTile(
                          title: const Text('Male'),
                          value: 'male',
                          groupValue: gender,
                          onChanged: (v) =>
                              setState(() => gender = v),
                        ),
                        RadioListTile(
                          title: const Text('Female'),
                          value: 'female',
                          groupValue: gender,
                          onChanged: (v) =>
                              setState(() => gender = v),
                        ),
                      ],
                    ),
                  ),

                  // EXPERIENCE (FULL WIDTH)
                  GridTile(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Experience: ${experience.toInt()} years'),
                        Slider(
                          min: 0,
                          max: 10,
                          divisions: 10,
                          value: experience,
                          onChanged: (v) =>
                              setState(() => experience = v),
                        ),
                      ],
                    ),
                  ),

                  // DATE
                  GridTile(
                    child: ListTile(
                      title: Text(
                        dob == null
                            ? 'Select Date of Birth'
                            : dob!
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                      ),
                      trailing:
                          const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => dob = picked);
                        }
                      },
                    ),
                  ),

                  // TIME
                  GridTile(
                    child: ListTile(
                      title: Text(
                        loginTime == null
                            ? 'Select Login Time'
                            : loginTime!.format(context),
                      ),
                      trailing:
                          const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() => loginTime = picked);
                        }
                      },
                    ),
                  ),

                  // SKILLS
                  GridTile(
                    child: MultiSelectDialogField<String>(
                      items: skillOptions
                          .map((e) => MultiSelectItem(e, e))
                          .toList(),
                      title: const Text('Skills'),
                      buttonText:
                          const Text('Select Skills'),
                      searchable: true,
                      initialValue: skills,
                      onConfirm: (values) {
                        setState(() => skills = values);
                      },
                    ),
                  ),

                  // RICH TEXT (FULL WIDTH)
                  GridTile(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bio',
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: QuillEditor.basic(
                              controller: richTextCtrl),
                        ),
                      ],
                    ),
                  ),

                  // TERMS
                  GridTile(
                    child: CheckboxListTile(
                      title:
                          const Text('I agree to terms'),
                      value: agree,
                      onChanged: (v) =>
                          setState(() => agree = v!),
                    ),
                  ),

                  // BUTTONS (FULL WIDTH)
                  GridTile(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: cancelForm,
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: submitForm,
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
