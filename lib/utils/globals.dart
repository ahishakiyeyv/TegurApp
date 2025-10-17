import 'package:flutter/foundation.dart';
import '../model/alert_model.dart';

// Existing:
final ValueNotifier<List<AlertModel>> activeAlerts =
    ValueNotifier<List<AlertModel>>([]);

// NEW: global notification toggle
final ValueNotifier<bool> notificationsEnabled = ValueNotifier<bool>(true);

// NEW: global selected language (display name or code as you prefer)
final ValueNotifier<String> appLanguage = ValueNotifier<String>('English');

// Optional list to drive the language selector
const supportedLanguages = <String>[
  'English',
  'Français',
  'Kiswahili',
  'Kirundi',
  'Español',
];
