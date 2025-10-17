import 'package:flutter/material.dart';

enum AlertSeverity { low, medium, high }

class AlertModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final String instructions;
  final DateTime start;
  final DateTime end;
  final AlertSeverity severity;

  const AlertModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.instructions,
    required this.start,
    required this.end,
    required this.severity,
  });

  String get severityLabel => switch (severity) {
    AlertSeverity.low => 'LOW',
    AlertSeverity.medium => 'MEDIUM',
    AlertSeverity.high => 'HIGH',
  };

  Color get severityColor => switch (severity) {
    AlertSeverity.low => const Color(0xFF22C55E),
    AlertSeverity.medium => const Color(0xFFF59E0B),
    AlertSeverity.high => const Color(0xFFEF4444),
  };
}
