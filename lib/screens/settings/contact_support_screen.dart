import 'package:flutter/material.dart';
import '_scaffold_gradient.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGradientScaffold(
      title: 'Contact Support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'If you need help with the app or want to report a bug, contact our team:',
          ),
          SizedBox(height: 12),
          Text('Email: support@floodwatch.example'),
          Text('Phone: +257 2220 3287'),
          SizedBox(height: 12),
          Text(
            'When contacting us, include your device model, app version, and steps to reproduce the issue.',
          ),
        ],
      ),
    );
  }
}
