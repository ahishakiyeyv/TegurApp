import 'package:flutter/material.dart';
import '../model/alert_model.dart';
import '../utils/api_sim.dart';
import '../utils/globals.dart';
import '../utils/firestore_helpers.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/alert_card.dart';
import 'alert_details_screen.dart';
import '../widgets/settings_sheet.dart'; // ⬅️ added
import 'tips_form_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  bool loading = true;
  List<AlertModel> actives = const [];
  List<AlertModel> past = const [];
  int navIndex = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Simulate two sources: local entity (actives) + Firestore (past)
    final a = await fetchLocalEntityAlertsSim();
    final p = await fetchAlertsFromFirestore();
    if (!mounted) return;
    setState(() {
      actives = a;
      past = p;
      loading = false;
      activeAlerts.value = a; // keep global in sync for Home variant
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navIndex,
        onTap: (i) {
          setState(() => navIndex = i);
          if (i == 0) {
            Navigator.of(context).pop();
          } // back to Home
          else if (i == 2) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TipsFormScreen()));
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C3AED), Color(0xFF2E1065)],
          ),
        ),
        child: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : _content(context),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                'Flood Alerts',
                style: t.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    showSettingsSheet(context), // ⬅️ open settings sheet
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Active Alerts (${actives.length})',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...actives.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AlertCard(
                alert: a,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlertDetailsScreen(alert: a),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Past Alerts (${past.length})',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...past.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AlertCard(
                alert: a,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlertDetailsScreen(alert: a),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
