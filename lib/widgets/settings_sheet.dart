import 'package:flutter/material.dart';

// ⬇️ Use your existing modal from onboarding
// Adjust the path if your file lives elsewhere under lib/
import 'language_selection_modal.dart';

import '../utils/globals.dart'; // for notificationsEnabled (from earlier step)
import '../screens/settings/terms_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/settings/contact_support_screen.dart';

Future<void> showSettingsSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.98),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Text(
                  'Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 1) Choose Language — reuses the same modal as onboarding.dart
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.translate),
              title: const Text('Choose Language'),
              subtitle: Text(_prettyLocaleName(context)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Your existing function (must exist in language_selection_modal.dart)
                await LanguageSelectionModal();
              },
            ),

            // 2) Notifications toggle (persists via global ValueNotifier from globals.dart)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ValueListenableBuilder<bool>(
                valueListenable: notificationsEnabled,
                builder: (_, enabled, __) => Row(
                  children: [
                    const Icon(Icons.notifications),
                    const SizedBox(width: 16),
                    const Expanded(child: Text('Set Notifications')),
                    Switch(
                      value: enabled,
                      onChanged: (v) => notificationsEnabled.value = v,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),

            // 3) Terms of Use
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Use'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const TermsScreen()));
              },
            ),

            // 4) Privacy Policy
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),

            // 5) Contact Support
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: const Icon(Icons.support_agent),
              title: const Text('Contact Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ContactSupportScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

String _prettyLocaleName(BuildContext context) {
  final locale = Localizations.localeOf(context);
  const map = {
    'en': 'English',
    'fr': 'Français',
    'sw': 'Kiswahili',
    'rn': 'Kirundi',
    'es': 'Español',
  };
  return map[locale.languageCode] ?? locale.toLanguageTag();
}
