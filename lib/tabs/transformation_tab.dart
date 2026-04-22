import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import '../models/user_profile.dart';

class TransformationTab extends StatefulWidget {
  final UserProfile profile;

  const TransformationTab({super.key, required this.profile});

  @override
  State<TransformationTab> createState() => _TransformationTabState();
}

class _TransformationTabState extends State<TransformationTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _poidsController = TextEditingController();
  List<Map<String, dynamic>> _weightHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWeightHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _poidsController.dispose();
    super.dispose();
  }

  Future<void> _loadWeightHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('weight_history');
    if (raw == null) return;
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    setState(() => _weightHistory = list);
  }

  Future<void> _saveWeight() async {
    final val = double.tryParse(_poidsController.text.trim().replaceAll(',', '.'));
    if (val == null || val < 20 || val > 300) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Entre un poids valide (20–300 kg)'),
        backgroundColor: Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final newHistory = [..._weightHistory, {'date': dateStr, 'poids': val}];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weight_history', jsonEncode(newHistory));

    setState(() {
      _weightHistory = newHistory;
      _poidsController.clear();
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('✅ Poids enregistré !'),
      backgroundColor: Color(0xFF1D9E75),
      behavior: SnackBarBehavior.floating,
    ));
  }

  int get _semaines {
    if (_weightHistory.isEmpty) return 0;
    final first = DateTime.parse(_weightHistory.first['date'] as String);
    return DateTime.now().difference(first).inDays ~/ 7;
  }

  // ── Indicateurs de progression (utilisés dans Ma projection) ──
  Map<String, double> get _indicateursProgress {
    switch (widget.profile.niveau) {
      case 'douceur':
        return {'souffle': 0.38, 'energie': 0.40, 'glycemie': 0.53};
      case 'actif':
        return {'souffle': 0.63, 'energie': 0.70, 'glycemie': 0.80};
      case 'tonification':
        return {'souffle': 0.75, 'energie': 0.80, 'glycemie': 0.67};
      default:
        return {'souffle': 0.50, 'energie': 0.50, 'glycemie': 0.33};
    }
  }

  List<Map<String, String>> get _programme {
    switch (widget.profile.niveau) {
      case 'douceur':
        return [
          {'icon': '🚶', 'text': 'Marche 20 min/jour les 2 premières semaines'},
          {'icon': '💧', 'text': '1.5L d\'eau minimum par jour'},
          {'icon': '🚫', 'text': 'Supprimer sodas et jus sucrés'},
          {'icon': '😴', 'text': 'Viser 7-8h de sommeil par nuit'},
          {'icon': '🧘', 'text': '5 min d\'étirements le matin'},
        ];
      case 'actif':
        return [
          {'icon': '🚶', 'text': 'Marche rapide 30 min/jour'},
          {'icon': '🏊', 'text': '2 séances natation ou vélo par semaine'},
          {'icon': '🍽️', 'text': 'Réduire les portions de 20%'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '😴', 'text': '7-8h de sommeil'},
        ];
      case 'tonification':
        return [
          {'icon': '🏃', 'text': '30 min cardio léger 4x/semaine'},
          {'icon': '💪', 'text': '2 séances muscu douce (squats, abdos, pompes)'},
          {'icon': '🥗', 'text': 'Alimentation équilibrée, léger déficit calorique'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '📱', 'text': 'Tracker tes repas 3x/semaine'},
        ];
      default:
        return [
          {'icon': '🏃', 'text': '30 min activité physique 5x/semaine'},
          {'icon': '🥗', 'text': 'Maintenir l\'équilibre alimentaire actuel'},
          {'icon': '💧', 'text': '2L d\'eau par jour'},
          {'icon': '📊', 'text': 'Peser-toi 1x/semaine le matin'},
        ];
    }
  }

  // ── Shared widgets ──

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _buildPhoto(bool isAfter) {
    const double h = 180;
    if (widget.profile.photoPath == null) {
      return Container(
        width: double.infinity,
        height: h,
        decoration: BoxDecoration(
          color: SonaColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.person, size: 60, color: SonaColors.primary),
      );
    }
    final useNetwork = kIsWeb ||
        widget.profile.photoPath!.startsWith('blob:') ||
        widget.profile.photoPath!.startsWith('http');
    final base = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: useNetwork
          ? Image.network(widget.profile.photoPath!,
              width: double.infinity, height: h, fit: BoxFit.cover)
          : Image.file(File(widget.profile.photoPath!),
              width: double.infinity, height: h, fit: BoxFit.cover),
    );
    if (!isAfter) return base;
    return SizedBox(
      width: double.infinity,
      height: h,
      child: Stack(fit: StackFit.expand, children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            1.05, 0, 0, 0, 12,
            0, 1.05, 0, 0, 12,
            0, 0, 1.05, 0, 12,
            0, 0, 0, 1, 0,
          ]),
          child: base,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: SonaColors.primary.withValues(alpha: 0.08),
          ),
        ),
      ]),
    );
  }

  Widget _buildIndicateur(
      String icon, String label, String valeur, double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (_, value, __) => Row(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A3D2B),
                        fontWeight: FontWeight.w500)),
                Text(valeur,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SonaColors.primary)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: const Color(0xFFE8E8E8),
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                minHeight: 8,
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // ── Onglet 1 : Ma projection ──

  Widget _buildProjectionTab() {
    final progress = _indicateursProgress;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(children: [
        // Carte avant/après
        _buildCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ta projection Sona 🌿',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F6E56))),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Aujourd\'hui',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF8A9E94))),
                      const SizedBox(height: 8),
                      _buildPhoto(false),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.profile.poids.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward,
                      color: SonaColors.primary, size: 20),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Dans 3 mois',
                          style: TextStyle(
                              fontSize: 12,
                              color: SonaColors.primary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _buildPhoto(true),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF5E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.profile.poidsCible.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B8A4F)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Projection estimée — résultats individuels variables.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8A9E94),
                  fontStyle: FontStyle.italic),
            ),
          ]),
        ),

        // Indicateurs santé
        _buildCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tes indicateurs à 3 mois',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F6E56))),
            const SizedBox(height: 16),
            _buildIndicateur('💨', 'Souffle',
                widget.profile.indicateurSouffle, progress['souffle']!),
            const SizedBox(height: 12),
            _buildIndicateur('⚡', 'Énergie',
                widget.profile.indicateurEnergie, progress['energie']!),
            const SizedBox(height: 12),
            _buildIndicateur('🩸', 'Glycémie',
                widget.profile.indicateurGlycemie, progress['glycemie']!),
          ]),
        ),

        // Programme de départ
        _buildCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ton programme de départ 🌱',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F6E56))),
            const SizedBox(height: 4),
            const Text('Semaines 1 à 4 — adapté à ton profil',
                style: TextStyle(fontSize: 12, color: Color(0xFF8A9E94))),
            const SizedBox(height: 16),
            ..._programme.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['icon']!,
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(item['text']!,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1A3D2B),
                                height: 1.4)),
                      ),
                    ],
                  ),
                )),
          ]),
        ),
      ]),
    );
  }

  // ── Onglet 2 : Mon évolution ──

  Widget _buildWeightChart() {
    if (_weightHistory.length < 2) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: const Text(
          'Enregistre ton poids chaque semaine\npour voir ta courbe 📊',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF8A9E94), height: 1.6),
        ),
      );
    }

    final spots = _weightHistory.asMap().entries.map((e) {
      return FlSpot(
          e.key.toDouble(), (e.value['poids'] as num).toDouble());
    }).toList();

    final allY = spots.map((s) => s.y).toList();
    final target = widget.profile.poidsCible;
    allY.add(target);
    final minY = allY.reduce((a, b) => a < b ? a : b) - 1.5;
    final maxY = allY.reduce((a, b) => a > b ? a : b) + 1.5;

    final targetSpots = [
      FlSpot(0, target),
      FlSpot((spots.length - 1).toDouble(), target),
    ];

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, meta) => Text(
                  '${v.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF8A9E94)),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= _weightHistory.length) {
                    return const SizedBox.shrink();
                  }
                  final date = DateTime.parse(
                      _weightHistory[idx]['date'] as String);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF8A9E94)),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF1D9E75),
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF1D9E75),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF1D9E75).withValues(alpha: 0.08),
              ),
            ),
            LineChartBarData(
              spots: targetSpots,
              isCurved: false,
              color: const Color(0xFF4CAF50).withValues(alpha: 0.45),
              barWidth: 1.5,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    final semaines = _semaines;
    final items = [
      ('💨', 'Souffle', widget.profile.indicateurSouffle),
      ('⚡', 'Énergie', widget.profile.indicateurEnergie),
      ('🩸', 'Glycémie', widget.profile.indicateurGlycemie),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (semaines > 0) ...[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SonaColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🗓 Semaine $semaines depuis le début',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F6E56),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Row(
          children: items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < items.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: SonaColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(item.$1,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(
                      item.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF5A8A6A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$3,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: SonaColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEvolutionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(children: [
        // Section 1 : Enregistrer le poids
        _buildCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ton poids ⚖️',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56))),
                const SizedBox(height: 4),
                const Text('Enregistre ton poids chaque semaine',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF9E9E9E))),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _poidsController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'Ex : 72.5',
                          hintStyle: TextStyle(
                              color: Color(0xFFAACCBB), fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          suffixText: 'kg',
                          suffixStyle: TextStyle(
                              color: Color(0xFF5A8A6A),
                              fontWeight: FontWeight.w500),
                        ),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A3D2B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveWeight,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SonaColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Enregistrer',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ]),
        ),

        // Section 2 : Courbe de poids
        _buildCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Courbe de poids 📈',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    if (_weightHistory.length >= 2)
                      Row(children: [
                        Container(
                          width: 12,
                          height: 2.5,
                          color: const Color(0xFF1D9E75),
                        ),
                        const SizedBox(width: 4),
                        const Text('Réel',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF8A9E94))),
                        const SizedBox(width: 10),
                        Container(
                          width: 12,
                          height: 1.5,
                          color: Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 4),
                        const Text('Cible',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF8A9E94))),
                      ]),
                  ],
                ),
                const SizedBox(height: 16),
                _buildWeightChart(),
              ]),
        ),

        // Section 3 : Tes indicateurs
        _buildCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tes indicateurs 🏅',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F6E56))),
                const SizedBox(height: 4),
                const Text('Projection à 3 mois selon ton profil',
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF9E9E9E))),
                const SizedBox(height: 14),
                _buildStatCards(),
              ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(children: [
          // TabBar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: SonaColors.primary,
              unselectedLabelColor: const Color(0xFF9E9E9E),
              indicatorColor: SonaColors.primary,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: const [
                Tab(text: 'Ma projection'),
                Tab(text: 'Mon évolution'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectionTab(),
                _buildEvolutionTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
