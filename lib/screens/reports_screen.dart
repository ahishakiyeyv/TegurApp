import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/report_card.dart';
import '../model/tip.dart';
import '../utils/firestore_tips_helpers.dart';
import 'report_details_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool loading = true;
  List<TipModel> tips = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await fetchTipsFromFirestore(); // simulated 3s
    if (!mounted) return;
    setState(() {
      tips = data
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest → oldest
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0 || i == 1) Navigator.of(context).maybePop();
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
              : Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        Text(
                          'Reports',
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemBuilder: (_, i) => ReportCard(
                          tip: tips[i],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReportDetailsScreen(tip: tips[i]),
                            ),
                          ),
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: tips.length,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
