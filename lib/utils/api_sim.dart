import 'dart:async';
import 'package:tegurapp/model/alert_model.dart';

/// Simulated OpenWeather fetch
Future<Map<String, dynamic>> fetchCurrentWeatherSim() async {
  await Future.delayed(const Duration(seconds: 3));
  return {
    "city": "Gatumba",
    "greeting": "Good Morning",
    "tempC": 21,
    "windKmh": 11,
    "humidityPct": 2,
    "sunHours": 8,
    "dateLabel": "Friday, 27th August",
    "hourly": const [
      {"label": "Now", "temp": 29},
      {"label": "5pm", "temp": 28},
      {"label": "6pm", "temp": 28},
      {"label": "7pm", "temp": 27},
    ],
    "world": const [
      {
        "country": "United States",
        "city": "California",
        "condition": "Mostly sunny",
        "temp": 32,
      },
      {
        "country": "United Kingdom",
        "city": "London",
        "condition": "Rainy",
        "temp": 17,
      },
      {"country": "France", "city": "Paris", "condition": "Cloudy", "temp": 23},
    ],
  };
}

/// Simulated local entity alert feed (separate from Firestore)
Future<List<AlertModel>> fetchLocalEntityAlertsSim() async {
  await Future.delayed(const Duration(seconds: 3));
  return [
    AlertModel(
      id: 'a1',
      title: 'Severe Flood Warning',
      location: 'Bujumbura',
      description:
          'River levels have exceeded danger levels. Immediate evacuation recommended for low-lying areas.',
      instructions:
          '1. Stay Informed.\n2. Avoid high-risk areas.\n3. Move to higher ground.',
      start: DateTime.now().subtract(const Duration(hours: 3)),
      end: DateTime.now().add(const Duration(days: 1)),
      severity: AlertSeverity.high,
    ),
    AlertModel(
      id: 'a2',
      title: 'Urban Flooding',
      location: 'Bujumbura',
      description: 'Streets waterlogged due to heavy monsoon rain.',
      instructions: 'Avoid driving in flooded streets. Follow local guidance.',
      start: DateTime.now().subtract(const Duration(hours: 17)),
      end: DateTime.now().add(const Duration(hours: 6)),
      severity: AlertSeverity.low,
    ),
  ];
}
