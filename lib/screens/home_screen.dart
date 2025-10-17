import 'package:flutter/material.dart';
import '../utils/api_sim.dart';
import '../utils/globals.dart';
import '../widgets/app_bottom_nav.dart';
import 'alerts_screen.dart';
import 'tips_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? data;
  bool loading = true;
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await fetchCurrentWeatherSim();
    if (!mounted) return;
    setState(() {
      data = d;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeAlerts,
      builder: (context, alerts, _) {
        final hasAlert = alerts.isNotEmpty;
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: AppBottomNav(
            currentIndex: navIndex,
            onTap: (i) {
              setState(() => navIndex = i);
              if (i == 1) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const AlertsScreen()));
              } else if (i == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TipsFormScreen()),
                );
              }
            },
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: hasAlert
                    ? const [
                        Color(0xFFEF4444),
                        Color(0xFF7C3AED),
                        Color(0xFF3730A3),
                      ]
                    : const [Color(0xFFFB923C), Color(0xFF7C3AED)],
              ),
            ),
            child: SafeArea(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : _content(context, hasAlert),
            ),
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, bool hasAlert) {
    final t = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data!['city'],
                      style: t.titleMedium?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data!['greeting'],
                      style: t.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasAlert)
                IconButton(
                  tooltip: 'View alerts',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AlertsScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.report_rounded,
                    size: 28,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Big weather illustration substitute
          Center(
            child: Icon(
              Icons.wb_sunny,
              size: 100,
              color: Colors.yellow.shade300,
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(
              '${data!['tempC']}°C',
              style: t.displayMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              data!['dateLabel'],
              style: t.titleMedium?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric(
                icon: Icons.air_rounded,
                label: '${data!['windKmh']}km/hr',
              ),
              _metric(
                icon: Icons.grain_rounded,
                label: '${data!['humidityPct']}%',
              ),
              _metric(
                icon: Icons.wb_sunny_outlined,
                label: '${data!['sunHours']}hr',
              ),
            ],
          ),

          const SizedBox(height: 16),
          _hourlyRow(),

          const SizedBox(height: 18),
          Center(
            child: Text(
              'Around the  World',
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),

          const SizedBox(height: 12),
          ...List<Widget>.from((data!['world'] as List).map(_worldTile)),
        ],
      ),
    );
  }

  Widget _metric({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _hourlyRow() {
    final hourly = data!['hourly'] as List;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: hourly.map<Widget>((h) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.06),
              border: Border.all(color: Colors.white.withOpacity(.25)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloudy_snowing, size: 20),
                const SizedBox(height: 6),
                Text(
                  '${h["label"]}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '${h["temp"]}°',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _worldTile(dynamic w) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        border: Border.all(color: Colors.white.withOpacity(.25)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${w["country"]}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  '${w["city"]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${w["condition"]}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.wb_sunny_outlined),
              const SizedBox(height: 10),
              Text(
                '${w["temp"]}°C',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
