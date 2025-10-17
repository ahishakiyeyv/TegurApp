import 'dart:async';
import 'package:tegurapp/model/alert_model.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

/// Fetch alerts from Firestore `alerts` collection.
Future<List<AlertModel>> fetchAlertsFromFirestore() async {
  await Future.delayed(const Duration(seconds: 3));
  // final snap = await FirebaseFirestore.instance.collection('alerts').orderBy('start', descending: true).get();
  // return snap.docs.map((d) => _fromDoc(d)).toList();

  // Static sample mirroring the design (as "past" list examples included on the Alerts screen):
  return [
    AlertModel(
      id: 'p1',
      title: 'Expired: Rain/Wet',
      location: 'Gatumba',
      description: 'Heavy rainfall across much of Burundi.',
      instructions: 'Stay cautious on the road.',
      start: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      end: DateTime.now().subtract(const Duration(hours: 2)),
      severity: AlertSeverity.medium,
    ),
    AlertModel(
      id: 'p2',
      title: 'Severe Flood Warning',
      location: 'Bujumbura',
      description:
          'River levels exceeded danger levels. Immediate evacuation recommended.',
      instructions: 'Follow local guidance.',
      start: DateTime.now().subtract(const Duration(days: 3)),
      end: DateTime.now().subtract(const Duration(days: 2)),
      severity: AlertSeverity.high,
    ),
  ];
}

/// Create a new alert in Firestore.
Future<void> createAlertInFirestore(AlertModel alert) async {
  await Future.delayed(const Duration(seconds: 1));
  // await FirebaseFirestore.instance.collection('alerts').add({
  //   'title': alert.title,
  //   'location': alert.location,
  //   'description': alert.description,
  //   'instructions': alert.instructions,
  //   'start': alert.start,
  //   'end': alert.end,
  //   'severity': alert.severity.name,
  // });
}

// If/when you use Firestore for real:
// AlertModel _fromDoc(DocumentSnapshot d) { ... }
