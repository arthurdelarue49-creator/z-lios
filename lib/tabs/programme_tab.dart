import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_profile.dart';

typedef ProgrammeTab = ProgrammeScreen;

// ─── ÉCRAN PROGRAMME ─────────────────────────────────────────────────────────

class ProgrammeScreen extends StatefulWidget {
  final UserProfile profile;

  const ProgrammeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends State<ProgrammeScreen> {
  // Obligatoires
  late String _marche;
  late String _calories;
  late String _eau;
  late String _sommeil;

  // Facultatifs (null = non sélectionné)
  String? _footing;
  String? _repas;
  String? _alcool;
  String? _coucherH;
  String? _stress;
  String? _pesee;

  final _sportController = TextEditingController();
  String _sportQuery = '';
  // Each entry: {'label': '🏊 Natation', 'frequence': null | '1x/semaine' ...}
  final List<Map<String, String?>> _selectedSports = [];

  static const _sportsList = [
    ('🏊', 'Natation'),
    ('🚴', 'Vélo'),
    ('🧘', 'Yoga'),
    ('💪', 'Musculation'),
    ('🏃', 'Running'),
    ('⛹️', 'Basketball'),
    ('⚽', 'Football'),
    ('🎾', 'Tennis'),
    ('🥊', 'Boxe'),
    ('🏋️', 'CrossFit'),
    ('🤸', 'Pilates'),
    ('🏊', 'Aquagym'),
    ('🧗', 'Escalade'),
    ('🤼', 'Arts martiaux'),
    ('🏇', 'Équitation'),
    ('⛷️', 'Ski'),
    ('🏄', 'Surf'),
    ('🚣', 'Aviron'),
    ('🤾', 'Handball'),
    ('🏐', 'Volleyball'),
    ('🏸', 'Badminton'),
    ('🥋', 'Judo'),
    ('🤺', 'Escrime'),
    ('🏒', 'Hockey'),
    ('🎿', 'Ski de fond'),
    ('🏌️', 'Golf'),
    ('🧶', 'Piloxing'),
    ('🚵', 'VTT'),
    ('🤽', 'Water-polo'),
    ('🎯', 'Tir à l\'arc'),
    ('🥌', 'Curling'),
    ('🏂', 'Snowboard'),
    ('🪂', 'Parachutisme'),
    ('🤿', 'Plongée'),
    ('🧁', 'Danse'),
    ('🎪', 'Cirque'),
    ('🏹', 'Tir sportif'),
    ('🤼', 'Lutte'),
    ('🚀', 'Zumba'),
    ('🌊', 'Kitesurf'),
  ];

  @override
  void initState() {
    super.initState();
    final imc = widget.profile.imc;
    _marche = imc >= 35 ? '15 min' : imc >= 30 ? '30 min' : imc >= 25 ? '45 min' : '1h';
    _calories = imc >= 35
        ? '1 400'
        : imc >= 30
            ? '1 700'
            : imc >= 25
                ? '2 000'
                : '2 300';
    _eau = imc >= 35 ? '1.5L' : '2L';
    _sommeil = '7h';
    _sportController.addListener(
        () => setState(() => _sportQuery = _sportController.text.toLowerCase()));
  }

  @override
  void dispose() {
    _sportController.dispose();
    super.dispose();
  }

  void _naviguerVersResultat({bool avecSport = true}) {
    final sportResume = avecSport && _selectedSports.isNotEmpty
        ? _selectedSports
            .map((s) =>
                '${s['label']} (${s['frequence'] ?? 'fréquence libre'})')
            .join(', ')
        : null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultatProgrammeScreen(
          profile: widget.profile,
          marche: _marche,
          calories: _calories,
          eau: _eau,
          sommeil: _sommeil,
          seances: null,
          footing: _footing,
          repas: _repas,
          alcool: _alcool,
          coucherH: _coucherH,
          stress: _stress,
          pesee: _pesee,
          sport: sportResume,
        ),
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                  color: SonaColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.lock_rounded,
                  color: SonaColors.primary, size: 30),
            ),
            const SizedBox(height: 16),
            const Text('Sona Premium 🌿',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F6E56))),
            const SizedBox(height: 10),
            const Text(
              'Le suivi de sports personnalisés est une fonctionnalité Premium. Débloquez-la pour enrichir votre programme.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A8A6A),
                  height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SonaColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text('Débloquer Sona Premium',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _naviguerVersResultat(avecSport: false);
              },
              child: const Text('Continuer sans sport →',
                  style:
                      TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  void _lancerProgramme() {
    if (_selectedSports.isNotEmpty) {
      _showPaywall(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Programme appliqué ✅'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF1D9E75),
          duration: Duration(seconds: 2),
        ),
      );
      _naviguerVersResultat();
    }
  }

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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

  Widget _buildCategorie(
    String titre,
    String sousTitre,
    List<String> valeurs,
    String selected,
    void Function(String) onSelect,
  ) =>
      _buildCategorieBase(
        titre: titre,
        sousTitre: sousTitre,
        valeurs: valeurs,
        selected: selected,
        onTap: onSelect,
      );

  Widget _buildCategorieFacultatif(
    String titre,
    String sousTitre,
    List<String> valeurs,
    String? selected,
    void Function(String?) onSelect,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.fromLTRB(20, 6, 16, 6),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        trailing: const Icon(Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF5A8A6A)),
        title: Row(children: [
          Expanded(
            child: Text(titre,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D4F3C))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Facultatif',
                style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 4),
        ]),
        children: [
          Text(sousTitre,
              style:
                  const TextStyle(fontSize: 12, color: Color(0xFF8A9E94))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: valeurs.map((v) {
              final sel = v == selected;
              return GestureDetector(
                onTap: () => setState(() => onSelect(sel ? null : v)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel
                        ? SonaColors.primary
                        : SonaColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sel
                          ? SonaColors.primary
                          : SonaColors.primaryBorder,
                    ),
                  ),
                  child: Text(v,
                      style: TextStyle(
                        color: sel ? Colors.white : SonaColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorieBase({
    required String titre,
    required String sousTitre,
    required List<String> valeurs,
    required String? selected,
    void Function(String)? onTap,
  }) =>
      _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D4F3C))),
            const SizedBox(height: 4),
            Text(sousTitre,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF8A9E94))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: valeurs.map((v) {
                final sel = v == selected;
                return GestureDetector(
                  onTap: () => onTap?.call(v),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel
                          ? SonaColors.primary
                          : SonaColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel
                            ? SonaColors.primary
                            : SonaColors.primaryBorder,
                      ),
                    ),
                    child: Text(v,
                        style: TextStyle(
                          color: sel ? Colors.white : SonaColors.primaryDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget _buildSportSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🏋️ Sport supplémentaire'),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ajouter un sport',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D4F3C))),
                const SizedBox(height: 2),
                const Text('(facultatif — Premium)',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E))),
                const SizedBox(height: 14),

                // ── Sports sélectionnés ──
                ..._selectedSports.asMap().entries.map((entry) {
                  final i = entry.key;
                  final sport = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: SonaColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Text(sport['label']!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () => setState(
                                  () => _selectedSports.removeAt(i)),
                              child: const Icon(Icons.close,
                                  color: Colors.white70, size: 18),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: ['1x/semaine', '2x/semaine', '3x/semaine', '4x/semaine']
                              .map((f) {
                            final sel = sport['frequence'] == f;
                            return GestureDetector(
                              onTap: () => setState(() =>
                                  _selectedSports[i]['frequence'] =
                                      sel ? null : f),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: sel
                                      ? SonaColors.primary
                                          .withValues(alpha: 0.12)
                                      : SonaColors.primaryLight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: sel
                                        ? SonaColors.primary
                                        : SonaColors.primaryBorder,
                                  ),
                                ),
                                child: Text(f,
                                    style: TextStyle(
                                      color: sel
                                          ? SonaColors.primary
                                          : SonaColors.primaryDark,
                                      fontWeight: sel
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 12,
                                    )),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),

                // ── Champ de recherche ──
                Container(
                  decoration: BoxDecoration(
                    color: SonaColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _sportController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un sport...',
                      hintStyle: const TextStyle(
                          color: Color(0xFFAACCBB), fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: _sportQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 18, color: Color(0xFF9E9E9E)),
                              onPressed: () => _sportController.clear(),
                            )
                          : null,
                    ),
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF1A3D2B)),
                  ),
                ),

                // ── Suggestions filtrées ──
                if (_sportQuery.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Builder(builder: (_) {
                    final already =
                        _selectedSports.map((s) => s['label']).toSet();
                    final suggestions = _sportsList
                        .where((s) =>
                            s.$2.toLowerCase().contains(_sportQuery) &&
                            !already.contains('${s.$1} ${s.$2}'))
                        .toList();
                    if (suggestions.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('Aucun sport trouvé.',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF9E9E9E))),
                      );
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: suggestions.map((s) {
                        final label = '${s.$1} ${s.$2}';
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedSports
                                .add({'label': label, 'frequence': null});
                            _sportController.clear();
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: SonaColors.primaryLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: SonaColors.primaryBorder),
                            ),
                            child: Text(label,
                                style: const TextStyle(
                                  color: SonaColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      );

  Widget _buildSectionHeader(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A8A6A),
                letterSpacing: 0.5)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const Expanded(
                    child: Text('Mon programme',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3D2B))),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Bannière info ──
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5EE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFB8DDC8), width: 1),
                      ),
                      child: const Row(children: [
                        Text('💡', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Les champs facultatifs sont optionnels — ton programme de base est calculé automatiquement',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF3A6B50),
                                height: 1.4),
                          ),
                        ),
                      ]),
                    ),

                    // ── Sport supplémentaire (en tête) ──
                    _buildSportSection(),

                    // ── Section 1 : Activité physique ──
                    _buildSectionHeader('🏃 Activité physique'),
                    _buildCategorie(
                      'Marche / jour',
                      'Durée de marche quotidienne recommandée',
                      ['15 min', '30 min', '45 min', '1h'],
                      _marche,
                      (v) => setState(() => _marche = v),
                    ),
                    _buildCategorie(
                      'Calories / jour',
                      'Objectif calorique indicatif',
                      ['1 400', '1 700', '2 000', '2 300'],
                      _calories,
                      (v) => setState(() => _calories = v),
                    ),
                    _buildCategorieFacultatif(
                      'Footing / semaine',
                      'Sorties course à pied',
                      ['1x', '2x', '3x', '4x'],
                      _footing,
                      (v) => setState(() => _footing = v),
                    ),

                    // ── Section 2 : Nutrition ──
                    _buildSectionHeader('🥗 Nutrition'),
                    _buildCategorieFacultatif(
                      'Repas / jour',
                      'Nombre de repas quotidiens',
                      ['2', '3', '4', '5'],
                      _repas,
                      (v) => setState(() => _repas = v),
                    ),
                    _buildCategorieFacultatif(
                      'Alcool',
                      'Consommation habituelle',
                      ['Jamais', 'Rarement', 'Week-end', 'Souvent'],
                      _alcool,
                      (v) => setState(() => _alcool = v),
                    ),

                    // ── Section 3 : Récupération ──
                    _buildSectionHeader('😴 Récupération'),
                    _buildCategorie(
                      'Eau / jour',
                      'Hydratation quotidienne',
                      ['1L', '1.5L', '2L', '2.5L'],
                      _eau,
                      (v) => setState(() => _eau = v),
                    ),
                    _buildCategorie(
                      'Sommeil / nuit',
                      'Durée de sommeil visée',
                      ['6h', '7h', '8h', '9h'],
                      _sommeil,
                      (v) => setState(() => _sommeil = v),
                    ),
                    _buildCategorieFacultatif(
                      'Heure de coucher',
                      'Heure à laquelle tu te couches',
                      ['21h', '22h', '23h', '00h'],
                      _coucherH,
                      (v) => setState(() => _coucherH = v),
                    ),
                    _buildCategorieFacultatif(
                      'Niveau de stress',
                      'Ressenti général en ce moment',
                      ['Faible', 'Modéré', 'Élevé'],
                      _stress,
                      (v) => setState(() => _stress = v),
                    ),

                    // ── Section 4 : Suivi ──
                    _buildSectionHeader('📊 Suivi'),
                    _buildCategorieFacultatif(
                      'Pesée',
                      'Fréquence de pesée recommandée',
                      ['1x/sem', '2x/sem', 'Quotidien'],
                      _pesee,
                      (v) => setState(() => _pesee = v),
                    ),


                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _lancerProgramme,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SonaColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text('Lancer mon programme 🚀',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ÉCRAN RÉSULTAT DU PROGRAMME ─────────────────────────────────────────────

class ResultatProgrammeScreen extends StatelessWidget {
  final UserProfile profile;
  final String marche;
  final String calories;
  final String eau;
  final String sommeil;
  final String? seances;
  final String? footing;
  final String? repas;
  final String? alcool;
  final String? coucherH;
  final String? stress;
  final String? pesee;
  final String? sport;

  const ResultatProgrammeScreen({
    super.key,
    required this.profile,
    required this.marche,
    required this.calories,
    required this.eau,
    required this.sommeil,
    this.seances,
    this.footing,
    this.repas,
    this.alcool,
    this.coucherH,
    this.stress,
    this.pesee,
    this.sport,
  });

  Map<String, double> get _progress {
    switch (profile.niveau) {
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

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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

  Widget _buildIndicateur(
      String icon, String label, String valeur, double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (_, value, _) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLigne(String icon, String label, String valeur) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A3D2B)))),
          Text(valeur,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SonaColors.primary)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final prog = _progress;
    final etapes = [
      ('Mois 1', 'Mise en route', 'Installer les habitudes'),
      ('Mois 2', 'Accélération', 'Le corps s\'adapte'),
      ('Mois 3', 'Transformation', 'Les vrais résultats arrivent'),
    ];

    // Lignes de base (obligatoires)
    final lignesBase = [
      ('🚶', 'Marche / jour', marche),
      ('🍽️', 'Calories / jour', calories),
      ('💧', 'Eau / jour', eau),
      ('😴', 'Sommeil', sommeil),
    ];

    // Lignes facultatives sélectionnées
    final lignesFac = <(String, String, String)>[
      if (seances != null) ('🏋️', 'Séances sport', seances!),
      if (footing != null) ('🏃', 'Footing', footing!),
      if (repas != null) ('🍴', 'Repas / jour', repas!),
      if (alcool != null) ('🍷', 'Alcool', alcool!),
      if (coucherH != null) ('🌙', 'Coucher', coucherH!),
      if (stress != null) ('🧘', 'Stress', stress!),
      if (pesee != null) ('⚖️', 'Pesée', pesee!),
      if (sport != null) ('🎯', 'Sport', sport!),
    ];

    return Scaffold(
      backgroundColor: SonaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: Color(0xFF1A3D2B)),
                    ),
                  ),
                  const Expanded(
                    child: Text('Ton programme est prêt !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A3D2B))),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  children: [
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tes objectifs semaine 1-4 🌱',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 16),
                          ...lignesBase.map((e) => _buildLigne(e.$1, e.$2, e.$3)),
                          if (lignesFac.isNotEmpty) ...[
                            const Divider(
                                height: 20, color: Color(0xFFF0F0F0)),
                            ...lignesFac
                                .map((e) => _buildLigne(e.$1, e.$2, e.$3)),
                          ],
                        ],
                      ),
                    ),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tes indicateurs à 3 mois',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 16),
                          _buildIndicateur('💨', 'Souffle',
                              profile.indicateurSouffle, prog['souffle']!),
                          _buildIndicateur('⚡', 'Énergie',
                              profile.indicateurEnergie, prog['energie']!),
                          _buildIndicateur('🩸', 'Glycémie',
                              profile.indicateurGlycemie, prog['glycemie']!),
                        ],
                      ),
                    ),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ta feuille de route 🗺️',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D4F3C))),
                          const SizedBox(height: 20),
                          ...etapes.asMap().entries.map((entry) {
                            final i = entry.key;
                            final e = entry.value;
                            final isLast = i == etapes.length - 1;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                        color: SonaColors.primary,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Text('${i + 1}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                        width: 2,
                                        height: 44,
                                        color: const Color(0xFF5DCAA5)),
                                ]),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: isLast ? 0 : 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.$1,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF8A9E94))),
                                        Text(e.$2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0D4F3C))),
                                        Text(e.$3,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF8A9E94))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SonaColors.primary,
                        side: const BorderSide(
                            color: SonaColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                      child: const Text('Recommencer une analyse',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
