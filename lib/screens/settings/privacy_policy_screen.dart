import 'package:flutter/material.dart';
import '_scaffold_gradient.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGradientScaffold(
      title: 'Privacy Policy',
      child: Text(
        'We collect limited information to provide weather alerts and community safety features. '
        'Data may include device identifiers, location (if granted), and user-submitted reports. '
        'Photos and text you submit are stored with timestamps and may be shared with municipal responders. '
        'We never sell personal data. You can request deletion of your data via Contact Support.',
      ),
    );
  }
}
