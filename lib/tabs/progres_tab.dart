import 'dart:convert';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressTab extends StatefulWidget {
  final double poids;
  final double taille;
  final int age;

  const ProgressTab({
    super.key,
    required this.poids,
    required this.taille,
    required this.age,
  });

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _mesures = [];

  double get _imc =>
      widget.poids / ((widget.taille / 100) * (widget.taille / 100));

  double get _poidsCible {
    if (_imc >= 35) return widget.poids * 0.96;
    if (_imc >= 30) return widget.poids * 0.94;
    if (_imc >= 25) return widget.poids * 0.95;
    return widget.poids * 0.98;
  }

  String get _niveau => _imc >= 35
      ? 'douceur'
      : _imc >= 30
          ? 'actif'
          : _imc >= 25
              ? 'tonification'
              : 'maintien';

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('sona_mesures') ?? '[]';
    setState(() => _mesures = List<Map<String, dynamic>>.from(
        (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e))));
  }

  Future<void> _enregistrer() async {
    final val = double.tryParse(_ctrl.text.trim());
    if (val == null || val < 20 || val > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Poids invalide')));
      return;
    }
    _mesures.add({'date': DateTime.now().toIso8601String(), 'poids': val});
    final p = await SharedPreferences.getInstance();
    await p.setString('sona_mesures', jsonEncode(_mesures));
    setState(() {});
    _ctrl.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Poids enregistré !')));
    }
  }

  Widget _buildGraphique() {
    if (_mesures.length < 2) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, color: Color(0xFFCCE8D8), size: 48),
              SizedBox(height: 8),
              Text(
                'Enregistre ton poids chaque semaine\npour voir ta courbe 📊',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    final spots = _mesures
        .asMap()
        .entries
        .map((e) =>
            FlSpot(e.key.toDouble(), (e.value['poids'] as num).toDouble()))
        .toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: const Color(0xFF1D9E75),
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF1D9E75),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, _poidsCible),
                FlSpot(spots.length - 1.0, _poidsCible),
              ],
              color: const Color(0xFF1D9E75).withValues(alpha: 0.35),
              barWidth: 1.5,
              dashArray: [5, 5],
              dotData: FlDotData(show: false),
            ),
          ],
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0F0F0), strokeWidth: 1),
            getDrawingVerticalLine: (_) =>
                const FlLine(color: Color(0xFFF0F0F0), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, _) => Text(
                  'S${v.toInt() + 1}',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9E9E9E)),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9E9E9E)),
                ),
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildBarre(
          String icon, String label, double fraction, Color color) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A3D2B),
                            fontWeight: FontWeight.w500)),
                    Text('${(fraction * 100).toInt()}%',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3D2B))),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(children: [
                    Container(height: 8, color: const Color(0xFFF0F0F0)),
                    FractionallySizedBox(
                      widthFactor: fraction,
                      child: Container(height: 8, color: color),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      );

  Widget _buildStatCard(
          String icon, String label, String valeur, bool isDown) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(icon, style: const TextStyle(fontSize: 18)),
                Text(
                  isDown ? '↓' : '↑',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D9E75)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(valeur,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F6E56))),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF5A8A6A))),
          ],
        ),
      );

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final ind = switch (_niveau) {
      'douceur' => ['+15%', '+20%', '-8%'],
      'actif' => ['+25%', '+35%', '-12%'],
      'tonification' => ['+30%', '+40%', '-10%'],
      _ => ['+20%', '+25%', '-5%'],
    };
    final semaines = _mesures.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            children: [
              // ── S1 : Saisie poids ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ton poids cette semaine ⚖️',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 4),
                    const Text('Mise à jour 1x/semaine suffit',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF9E9E9E))),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            Expanded(
                              child: TextField(
                                controller: _ctrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  hintText: 'Ex: 82.5',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(
                                      color: Color(0xFFAACCBB),
                                      fontSize: 14),
                                ),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1A3D2B)),
                              ),
                            ),
                            const Text('kg',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF5A8A6A),
                                    fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _enregistrer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D9E75),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text('Enregistrer',
                            style:
                                TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ],
                ),
              ),

              // ── S2 : Graphique ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Courbe de poids 📉',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 16),
                    _buildGraphique(),
                  ],
                ),
              ),

              // ── S3 : Objectifs hebdo ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tes objectifs cette semaine',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 14),
                    _buildBarre(
                        '🚶', 'Pas', 0.65, const Color(0xFF1D9E75)),
                    _buildBarre(
                        '💧', 'Eau', 0.80, const Color(0xFF378ADD)),
                    _buildBarre(
                        '🍽️', 'Calories', 0.70, const Color(0xFFEF9F27)),
                  ],
                ),
              ),

              // ── S4 : Indicateurs évolution ──
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tes indicateurs',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F6E56))),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.4,
                      children: [
                        _buildStatCard('💨', 'Souffle', ind[0], false),
                        _buildStatCard('⚡', 'Énergie', ind[1], false),
                        _buildStatCard('🩸', 'Glycémie', ind[2], true),
                        _buildStatCard(
                            '📅', 'Semaines actives', '$semaines sem.', false),
                      ],
                    ),
                  ],
                ),
              ),

              // ── S5 : Projections premium floutées ──
              _buildCard(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(children: [
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        height: 160,
                        decoration: const BoxDecoration(
                            color: Color(0xFFE8F5EE)),
                        child: const Center(
                          child: Icon(Icons.show_chart,
                              size: 80, color: Color(0xFF5DCAA5)),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                            color:
                                Colors.white.withValues(alpha: 0.5)),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔒',
                                style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8),
                            const Text(
                              'Projections 6 et 12 mois',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F6E56)),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                              '🚧 Paiement à venir !'))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF1D9E75),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 0,
                              ),
                              child: const Text(
                                  'Débloquer les projections',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
