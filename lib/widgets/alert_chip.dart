import 'package:flutter/material.dart';
import 'package:tegurapp/model/alert_model.dart';

class AlertChip extends StatelessWidget {
  final AlertModel alert;
  const AlertChip({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: alert.severityColor.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        alert.severityLabel,
        style: TextStyle(
          color: alert.severityColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
