import 'dart:async';
import '../model/tip.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

/// Create a tip/report document in Firestore (simulated).
Future<void> createTipInFirestore(TipModel tip) async {
  await Future.delayed(const Duration(seconds: 3));
  // await FirebaseFirestore.instance.collection('tips').add({
  //   'title': tip.title,
  //   'location': tip.location,
  //   'description': tip.description,
  //   'imageUrl': tip.imageUrl,
  //   'submittedBy': tip.submittedBy,
  //   'createdAt': tip.createdAt,
  // });
}

/// Fetch tips ordered newest → oldest (simulated).
Future<List<TipModel>> fetchTipsFromFirestore() async {
  await Future.delayed(const Duration(seconds: 3));
  // final q = await FirebaseFirestore.instance.collection('tips').orderBy('createdAt', descending: true).get();
  // return q.docs.map((d) => TipModel(...)).toList();

  final now = DateTime.now();
  return [
    TipModel(
      id: 't1',
      title: 'Road flooding on Main Street',
      location: 'Bujumbura',
      description:
          'Water level is about 2 feet deep, cars getting stuck. Need immediate attention.',
      imageUrl:
          'https://images.unsplash.com/photo-1520975930270-3b3370f2a9a2?q=80&w=1200&auto=format&fit=crop',
      submittedBy: 'Community',
      createdAt: now.subtract(const Duration(days: 2, hours: 3)),
    ),
    TipModel(
      id: 't2',
      title: 'Bridge overflow near City Market',
      location: 'Bujumbura',
      description:
          'River overflow on the small bridge; pedestrians crossing dangerously.',
      imageUrl:
          'https://images.unsplash.com/photo-1603297632251-c3f8a2c18d9a?q=80&w=1200&auto=format&fit=crop',
      submittedBy: 'Community',
      createdAt: now.subtract(const Duration(days: 3, hours: 1)),
    ),
    TipModel(
      id: 't3',
      title: 'Mudslide risk by Riverside Rd',
      location: 'Gatumba',
      description: 'Soaked slopes with minor slides already on the roadside.',
      imageUrl:
          'https://images.unsplash.com/photo-1519834785169-98be25ec3f84?q=80&w=1200&auto=format&fit=crop',
      submittedBy: 'Community',
      createdAt: now.subtract(const Duration(days: 4, hours: 6)),
    ),
  ];
}
