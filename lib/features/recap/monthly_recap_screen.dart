import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/daily_report.dart';
import '../../core/services/coin_service.dart';
import '../../core/services/monthly_recap_service.dart';
import '../../core/services/providers.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/theme/colors.dart';
import '../../shared/widgets/coin_widgets.dart';
import 'recap_charts.dart';

/// Bilan mensuel façon "stories" : ~1 minute pour revivre son mois
class MonthlyRecapScreen extends ConsumerStatefulWidget {
  final RecapMonth month;

  const MonthlyRecapScreen({super.key, required this.month});

  static Future<void> open(BuildContext context, RecapMonth month) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MonthlyRecapScreen(month: month),
      ),
    );
  }

  @override
  ConsumerState<MonthlyRecapScreen> createState() => _MonthlyRecapScreenState();
}

class _Slide {
  final List<Color> gradient;
  final Widget Function(BuildContext) builder;
  const _Slide(this.gradient, this.builder);
}

class _MonthlyRecapScreenState extends ConsumerState<MonthlyRecapScreen>
    with SingleTickerProviderStateMixin {
  static const _slideDuration = Duration(seconds: 8);

  late final AnimationController _progress;
  final _pageController = PageController();

  MonthlyRecap? _recap;
  Object? _error;
  List<_Slide> _slides = const [];
  int _index = 0;

  /// Catcoins offerts à l'instant pour ce bilan (0 s'ils l'étaient déjà)
  int _bonus = 0;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: _slideDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _load();
  }

  Future<void> _load() async {
    try {
      // Appels directs aux services : données toujours fraîches à l'ouverture
      final recap = await ref
          .read(monthlyRecapServiceProvider)
          .build(widget.month);
      if (!mounted) return;
      setState(() {
        _recap = recap;
        _slides = _buildSlides(recap);
      });
      if (_slides.length <= 1) _markSeen();
      _progress.forward(from: 0);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _slides.length - 1;

  void _goTo(int index) {
    if (index < 0 || index >= _slides.length) return;
    HapticService.selection();
    setState(() => _index = index);
    _pageController.jumpToPage(index);
    if (_isLast) {
      _progress.value = 1; // pas de défilement automatique sur la dernière
      _markSeen();
    } else {
      _progress.forward(from: 0);
    }
  }

  void _next() => _goTo(_index + 1);
  void _previous() => _goTo(_index - 1);

  /// Arrivée sur la dernière page : le bilan est vu (la bannière s'adoucit)
  /// et le cadeau du mois est versé la toute première fois.
  Future<void> _markSeen() async {
    final coins = ref.read(coinServiceProvider);
    final bonus = await coins.markRecapSeen(
      widget.month.year,
      widget.month.month,
    );
    if (!mounted) return;
    ref.invalidate(recapSeenProvider(widget.month));
    if (bonus > 0) {
      HapticService.success();
      setState(() => _bonus = bonus);
    }
  }

  // ==================== HELPERS DE TEXTE ====================

  String get _monthName => DateFormat.MMMM('fr_FR').format(widget.month.start);
  String get _prevMonthName =>
      DateFormat.MMMM('fr_FR').format(widget.month.previous.start);

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _plural(int n, String singular, [String? plural]) =>
      n > 1 ? (plural ?? '${singular}s') : singular;

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    if (m == 60) return '${h + 1}h';
    return m == 0 ? '${h}h' : '${h}h${m.toString().padLeft(2, '0')}';
  }

  /// Phrase de comparaison avec le mois précédent
  String? _compare(
    num? current,
    num? previous, {
    required bool lowerIsBetter,
    required String unit,
    bool isHours = false,
  }) {
    if (current == null || previous == null) return null;
    final diff = current - previous;
    final absText = isHours
        ? _formatHours(diff.abs().toDouble())
        : '${diff.abs().round()} $unit';
    if ((isHours && diff.abs() < 0.17) || (!isHours && diff.round() == 0)) {
      return '= Comme en $_prevMonthName';
    }
    final better = lowerIsBetter ? diff < 0 : diff > 0;
    final arrow = diff < 0 ? '↓' : '↑';
    final word = diff < 0 ? 'de moins' : 'de plus';
    return '$arrow $absText $word qu\'en $_prevMonthName${better ? ' 🎉' : ''}';
  }

  // ==================== SLIDES ====================

  List<_Slide> _buildSlides(MonthlyRecap r) {
    return [
      _Slide(const [
        WakyColors.primaryDark,
        WakyColors.accent,
      ], (c) => _introSlide(c, r)),
      if (r.daysTracked > 0)
        _Slide(const [
          Color(0xFF6A1B9A),
          Color(0xFF3949AB),
        ], (c) => _calendarSlide(c, r)),
      if (r.hasData)
        _Slide(const [
          Color(0xFFD81B60),
          Color(0xFFFF7043),
        ], (c) => _painSlide(c, r)),
      if (r.bestDay != null)
        _Slide(const [
          Color(0xFFFFA000),
          Color(0xFFFF7043),
        ], (c) => _bestDaySlide(c, r)),
      if (r.topFoods.isNotEmpty)
        _Slide(const [
          Color(0xFF2E7D32),
          Color(0xFF00897B),
        ], (c) => _foodSlide(c, r)),
      if (r.daysTracked > 0)
        _Slide(const [
          Color(0xFF283593),
          Color(0xFF5E35B1),
        ], (c) => _sleepSlide(c, r)),
      _Slide(const [
        Color(0xFFF57C00),
        Color(0xFFC2185B),
      ], (c) => _rewardsSlide(c, r)),
    ];
  }

  TextStyle get _title => const TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  TextStyle get _body => TextStyle(
    color: Colors.white.withValues(alpha: 0.9),
    fontSize: 16,
    height: 1.4,
  );

  TextStyle get _hero => const TextStyle(
    color: Colors.white,
    fontSize: 72,
    fontWeight: FontWeight.w800,
    height: 1,
  );

  Widget _comparisonLine(String? text) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: _body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _introSlide(BuildContext context, MonthlyRecap r) {
    final ratio = r.daysCounted == 0 ? 0 : r.daysTracked / r.daysCounted;
    final message = !r.hasData
        ? 'Pas encore de journal ce mois-ci… le prochain bilan sera encore plus beau ✨'
        : ratio >= 0.9
        ? 'Une régularité incroyable, bravo ! 🏆'
        : ratio >= 0.6
        ? 'Quelle belle régularité, continue comme ça ! 🌟'
        : 'Chaque journal compte, merci de prendre soin de toi 💜';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ton bilan de', style: _body.copyWith(fontSize: 20)),
        Text(
          '${_capitalize(_monthName)} ${widget.month.year}',
          style: _title.copyWith(fontSize: 38),
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CountUpText(value: r.daysTracked, style: _hero),
            const SizedBox(width: 8),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '/ ${r.daysCounted}\n${_plural(r.daysTracked, 'jour noté', 'jours notés')}',
                  style: _body,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (r.longestStreak > 1)
          Text(
            '🔥 Plus longue série : ${r.longestStreak} jours d\'affilée',
            style: _body,
          ),
        const SizedBox(height: 24),
        Text(
          message,
          style: _body.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _calendarSlide(BuildContext context, MonthlyRecap r) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ton mois en couleurs', style: _title),
        const SizedBox(height: 20),
        RecapPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecapCalendar(
                month: r.month,
                dailyStatus: r.dailyStatus,
                daysCounted: r.daysCounted,
              ),
              const SizedBox(height: 12),
              RecapStatusLegend(counts: r.statusCounts),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CountUpText(value: r.goodDays, style: _hero.copyWith(fontSize: 56)),
            const SizedBox(width: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _plural(r.goodDays, 'belle journée', 'belles journées'),
                  style: _body,
                ),
              ),
            ),
          ],
        ),
        _comparisonLine(
          _compare(
            r.goodDays,
            r.prevGoodDays,
            lowerIsBetter: false,
            unit: 'jour(s)',
          ),
        ),
      ],
    );
  }

  Widget _painSlide(BuildContext context, MonthlyRecap r) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Côté douleurs', style: _title),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CountUpText(value: r.painFreeDays, style: _hero),
            const SizedBox(width: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _plural(
                    r.painFreeDays,
                    'jour\nsans douleur',
                    'jours\nsans douleur',
                  ),
                  style: _body,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (r.painCount == 0)
          Text(
            'Aucune douleur notée ce mois-ci 🎉',
            style: _body.copyWith(fontSize: 20),
          )
        else ...[
          RecapPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intensité max par jour (1 à 5)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                RecapPainBars(
                  dailyMaxPain: r.dailyMaxPain,
                  daysCounted: r.daysCounted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${r.painCount} ${_plural(r.painCount, 'douleur notée', 'douleurs notées')}'
            ' · intensité moyenne ${r.avgPainIntensity!.toStringAsFixed(1)}/5',
            style: _body,
          ),
        ],
        _comparisonLine(
          _compare(
            r.painCount,
            r.prevPainCount,
            lowerIsBetter: true,
            unit: 'douleur(s)',
          ),
        ),
      ],
    );
  }

  Widget _bestDaySlide(BuildContext context, MonthlyRecap r) {
    final style = DayStatusStyle.of(r.bestDayStatus ?? DayStatus.good);
    final date = DateFormat('EEEE d MMMM', 'fr_FR').format(r.bestDay!);
    final pain = r.dailyMaxPain[r.bestDay!.day - 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ta plus belle journée',
          style: _title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.4, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (context, s, child) =>
              Transform.scale(scale: s, child: child),
          child: Text(style.emoji, style: const TextStyle(fontSize: 110)),
        ),
        const SizedBox(height: 24),
        Text(
          _capitalize(date),
          style: _title.copyWith(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Journée ${style.label.toLowerCase()}${pain == 0 ? ', sans aucune douleur' : ''}',
          style: _body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Text(
          'Garde ce souvenir en tête 💜',
          style: _body.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  Widget _foodList(String title, List<FoodCount> foods, {String? note}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          if (note != null)
            Text(
              note,
              style: const TextStyle(
                fontSize: 12,
                color: WakyColors.textSecondaryLight,
              ),
            ),
          const SizedBox(height: 6),
          for (final f in foods)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _capitalize(f.name),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '×${f.count}',
                    style: const TextStyle(
                      color: WakyColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _foodSlide(BuildContext context, MonthlyRecap r) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dans ton assiette', style: _title),
        const SizedBox(height: 20),
        RecapPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _foodList('🍽️ Tes incontournables', r.topFoods),
              if (r.wellToleratedFoods.isNotEmpty)
                _foodList(
                  '💚 Bien tolérés',
                  r.wellToleratedFoods,
                  note: 'Mangés plusieurs fois, sans douleur liée',
                ),
              if (r.watchFoods.isNotEmpty)
                _foodList(
                  '👀 À surveiller',
                  r.watchFoods,
                  note: 'Souvent notés avant une douleur',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sleepSlide(BuildContext context, MonthlyRecap r) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sommeil & énergie', style: _title),
        const SizedBox(height: 20),
        if (r.avgSleepHours != null) ...[
          Text(_formatHours(r.avgSleepHours!), style: _hero),
          const SizedBox(height: 4),
          Text('de sommeil en moyenne par nuit 😴', style: _body),
          _comparisonLine(
            _compare(
              r.avgSleepHours,
              r.prevAvgSleepHours,
              lowerIsBetter: false,
              unit: '',
              isHours: true,
            ),
          ),
        ],
        const SizedBox(height: 24),
        RecapPanel(
          child: Column(
            children: [
              RecapMeter(
                emoji: '🛏️',
                label: 'Qualité du sommeil',
                value: r.avgSleepQuality,
                color: WakyColors.primary,
              ),
              RecapMeter(
                emoji: '🧘',
                label: 'Stress',
                value: r.avgStress,
                color: WakyColors.primary,
              ),
              RecapMeter(
                emoji: '🔋',
                label: 'Fatigue',
                value: r.avgFatigue,
                color: WakyColors.primary,
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Moyennes du mois, sur 5',
                  style: TextStyle(
                    fontSize: 12,
                    color: WakyColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rewardTile(Widget icon, int value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(height: 36, child: Center(child: icon)),
            const SizedBox(height: 6),
            CountUpText(
              value: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: _body.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardsSlide(BuildContext context, MonthlyRecap r) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tes récompenses du mois', style: _title),
        const SizedBox(height: 24),
        Row(
          children: [
            _rewardTile(
              const Text('🐱', style: TextStyle(fontSize: 30)),
              r.newCats,
              _plural(r.newCats, 'nouveau chat', 'nouveaux chats'),
            ),
            const SizedBox(width: 10),
            _rewardTile(
              const Text('🍽️', style: TextStyle(fontSize: 30)),
              r.newFoodCards,
              _plural(r.newFoodCards, 'nouveau plat', 'nouveaux plats'),
            ),
            const SizedBox(width: 10),
            _rewardTile(
              const CatCoinIcon(size: 34),
              r.coinsEarned,
              CoinRewards.currencyName,
            ),
          ],
        ),
        if (_bonus > 0) ...[
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('🎁 ', style: TextStyle(fontSize: 16)),
                  CoinGainLabel(
                    amount: _bonus,
                    style: _body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(' pour ton bilan', style: _body.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
        Text(
          'Merci de prendre soin de toi ce mois-ci 💜',
          style: _body.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFC2185B),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Fermer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    if (_recap == null) {
      return Scaffold(
        backgroundColor: WakyColors.primaryDark,
        body: Center(
          child: _error != null
              ? Text(
                  'Impossible de charger le bilan\n$_error',
                  style: _body,
                  textAlign: TextAlign.center,
                )
              : const CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final gradient = _slides[_index].gradient;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 3) {
                _previous();
              } else {
                _next();
              }
            },
            onLongPressStart: (_) => _progress.stop(),
            onLongPressEnd: (_) {
              if (!_isLast) _progress.forward();
            },
            child: Column(
              children: [
                _buildProgressBars(),
                _buildHeader(context),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _slides.length,
                    itemBuilder: (context, i) => SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: Center(child: _slides[i].builder(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBars() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) => Row(
          children: [
            for (var i = 0; i < _slides.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: i < _index
                          ? 1
                          : (i == _index ? _progress.value : 0),
                      minHeight: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 4, 0),
      child: Row(
        children: [
          Text(
            'Bilan mensuel',
            style: _body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Fermer',
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
