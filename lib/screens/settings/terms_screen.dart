import 'package:flutter/material.dart';
import '_scaffold_gradient.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGradientScaffold(
      title: 'Terms of Use',
      child: const Text(
        'These Terms of Use govern your access to and use of the application. '
        'By using the app, you agree to: (1) submit accurate information; '
        '(2) avoid misuse or harmful behavior; (3) respect local laws and emergency guidance. '
        'Community reports may be publicly visible and may be shared with local authorities. '
        'The app is provided on an “as is” basis; we do not guarantee uninterrupted service. '
        'Your continued use constitutes acceptance of any updated terms.',
      ),
    );
  }
}
