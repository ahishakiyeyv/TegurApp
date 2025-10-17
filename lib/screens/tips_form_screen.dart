// lib/screens/tips_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/settings_sheet.dart';

import '../model/tip.dart';
import '../utils/imgbb_uploader.dart';
import '../utils/firestore_tips_helpers.dart';

// Bottom-nav destinations:
import 'home_screen.dart';
import 'alerts_screen.dart';
import 'tip_sent_screen.dart';
import 'reports_screen.dart'; // ⬅️ go to reports when tapping the arrow

class TipsFormScreen extends StatefulWidget {
  const TipsFormScreen({super.key});
  @override
  State<TipsFormScreen> createState() => _TipsFormScreenState();
}

class _TipsFormScreenState extends State<TipsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationCtrl = TextEditingController();
  final _dateTimeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();

  File? _imageFile;
  bool _submitting = false;
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _dateTimeCtrl.dispose();
    _descCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      _selectedDateTime = dt;
      _dateTimeCtrl.text = DateFormat('yyyy-MM-dd HH:mm').format(dt);
    });
  }

  Future<void> _takePicture() async {
    // TODO: Replace with ImagePicker(camera) and permission handling.
    setState(() => _imageFile = File('/tmp/fake_camera_image.jpg'));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    // 1) Upload image (simulated)
    String imageUrl = '';
    if (_imageFile != null) {
      imageUrl = await uploadImageToImgBBSim(_imageFile!);
    }

    // 2) Create model
    final tip = TipModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim().isEmpty
          ? 'Community Report'
          : _titleCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageUrl: imageUrl,
      submittedBy: 'Community',
      createdAt: _selectedDateTime ?? DateTime.now(),
    );

    // 3) Persist (simulated Firestore)
    await createTipInFirestore(tip);

    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const TipSentScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2, // Tips tab active
        onTap: (i) {
          if (i == 0) {
            // Home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (i == 1) {
            // Alerts
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AlertsScreen()),
            );
          } else if (i == 2) {
            // Tips → already here
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    Text(
                      'Tips',
                      style: t.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => showSettingsSheet(context),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Header card (with arrow to Reports)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(.25)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Community Alerts',
                              style: t.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "I see signs of flooding. I'm reporting to help keep my community informed, prepared, and safe.",
                              style: t.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ⬇️ Arrow button navigates to Reports screen
                      IconButton(
                        tooltip: 'View Reports',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReportsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _AppField(
                        controller: _titleCtrl,
                        label: 'Title',
                        icon: Icons.edit_note,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please add a title'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _AppField(
                        controller: _locationCtrl,
                        label: 'Location',
                        icon: Icons.place_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a location'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _AppField(
                              controller: _dateTimeCtrl,
                              label: 'Date & Time',
                              readOnly: true,
                              icon: Icons.calendar_today,
                              onTap: _pickDateTime,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Select date/time'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AppField(
                              controller: TextEditingController(
                                text: _imageFile != null
                                    ? '1 photo selected'
                                    : '',
                              ),
                              label: 'Take Picture',
                              readOnly: true,
                              icon: Icons.photo_camera_outlined,
                              onTap: _takePicture,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _AppField(
                        controller: _descCtrl,
                        label: 'Description',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Describe what you observed'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Submit Report',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                Text(
                  'Preparedness Tips',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ...[
                  'Before Flood',
                  'During Flood',
                  'After Flood',
                ].map((s) => _TipTile(title: s)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final int maxLines;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const _AppField({
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(.25)),
        ),
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  final String title;
  const _TipTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
