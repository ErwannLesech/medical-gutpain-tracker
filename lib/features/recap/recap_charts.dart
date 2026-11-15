import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/models/daily_report.dart';
import '../../core/services/monthly_recap_service.dart';
import '../../shared/theme/colors.dart';

/// Libellé, emoji et couleur de statut d'une journée
/// (la couleur n'est jamais seule : toujours accompagnée de l'emoji/libellé)
class DayStatusStyle {
  final String emoji;
  final String label;
  final Color color;
  const DayStatusStyle(this.emoji, this.label, this.color);

  static DayStatusStyle of(DayStatus status) {
    switch (status) {
      case DayStatus.excellent:
        return const DayStatusStyle('😄', 'Excellente', WakyColors.dayExcellent);
      case DayStatus.good:
        return const DayStatusStyle('🙂', 'Bonne', WakyColors.dayGood);
      case DayStatus.average:
        return const DayStatusStyle('😐', 'Moyenne', WakyColors.dayAverage);
      case DayStatus.difficult:
        return const DayStatusStyle('😔', 'Difficile', WakyColors.dayDifficult);
      case DayStatus.terrible:
        return const DayStatusStyle('😢', 'Très difficile', WakyColors.dayTerrible);
    }
  }
}

/// Carte blanche sur laquelle reposent les graphiques des stories
class RecapPanel extends StatelessWidget {
  final Widget child;
  const RecapPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: WakyColors.textPrimaryLight),
        child: child,
      ),
    );
  }
}

/// Calendrier du mois : chaque jour coloré selon l'état de la journée
class RecapCalendar extends StatelessWidget {
  final RecapMonth month;
  final List<DayStatus?> dailyStatus;
  final int daysCounted;

  const RecapCalendar({
    super.key,
    required this.month,
    required this.dailyStatus,
    required this.daysCounted,
  });

  @override
  Widget build(BuildContext context) {
    // Lundi = 0
    final offset = (month.start.weekday - 1) % 7;
    final totalCells = offset + month.daysInMonth;
    final rows = (totalCells / 7).ceil();
    const weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        Row(
          children: [
            for (final d in weekDays)
              Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 11,
                      color: WakyColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var row = 0; row < rows; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(child: _cell(row * 7 + col - offset)),
            ],
          ),
      ],
    );
  }

  Widget _cell(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= month.daysInMonth) {
      return const AspectRatio(aspectRatio: 1, child: SizedBox());
    }
    final status = dailyStatus[dayIndex];
    final isFuture = dayIndex >= daysCounted;
    final style = status != null ? DayStatusStyle.of(status) : null;

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        // 2px d'espace entre les cases (1px de chaque côté)
        padding: const EdgeInsets.all(1),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + dayIndex * 18),
          curve: Curves.easeOut,
          builder: (context, t, child) => Opacity(opacity: t, child: child),
          child: Container(
            decoration: BoxDecoration(
              color: style?.color ??
                  (isFuture ? Colors.grey.shade100 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: style != null
                ? Text(style.emoji, style: const TextStyle(fontSize: 14))
                : Text(
                    '${dayIndex + 1}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Légende du calendrier avec le nombre de jours par état
class RecapStatusLegend extends StatelessWidget {
  final Map<DayStatus, int> counts;

  const RecapStatusLegend({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final status in DayStatus.values)
          if ((counts[status] ?? 0) > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: DayStatusStyle.of(status).color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${DayStatusStyle.of(status).label} · ${counts[status]}',
                  style: const TextStyle(fontSize: 12, color: WakyColors.textSecondaryLight),
                ),
              ],
            ),
      ],
    );
  }
}

/// Barres de douleur par jour (une seule série, une seule couleur)
class RecapPainBars extends StatelessWidget {
  final List<int> dailyMaxPain;
  final int daysCounted;

  const RecapPainBars({
    super.key,
    required this.dailyMaxPain,
    required this.daysCounted,
  });

  @override
  Widget build(BuildContext context) {
    final n = dailyMaxPain.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 110,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) => CustomPaint(
              painter: _PainBarsPainter(dailyMaxPain, daysCounted, t),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Axe X : 1, milieu, fin de mois
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _axisLabel('1'),
            _axisLabel('${(n / 2).ceil()}'),
            _axisLabel('$n'),
          ],
        ),
      ],
    );
  }

  Widget _axisLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 10, color: WakyColors.textSecondaryLight),
      );
}

class _PainBarsPainter extends CustomPainter {
  final List<int> values;
  final int daysCounted;
  final double progress;

  _PainBarsPainter(this.values, this.daysCounted, this.progress);

  static const _barColor = WakyColors.accent;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    const gap = 2.0;
    final barWidth = max(1.0, (size.width - gap * (n - 1)) / n);

    // Ligne de base (hairline)
    canvas.drawLine(
      Offset(0, size.height - 0.5),
      Offset(size.width, size.height - 0.5),
      Paint()
        ..color = Colors.grey.shade300
        ..strokeWidth = 1,
    );

    for (var i = 0; i < n; i++) {
      final x = i * (barWidth + gap);
      final v = values[i];
      if (v == 0) {
        if (i < daysCounted) {
          // Jour sans douleur : petit point discret
          canvas.drawCircle(
            Offset(x + barWidth / 2, size.height - 4),
            min(2, barWidth / 2),
            Paint()..color = Colors.grey.shade300,
          );
        }
        continue;
      }
      final h = (size.height - 2) * (v / 5) * progress;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, size.height - h, barWidth, h),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = _barColor);
    }
  }

  @override
  bool shouldRepaint(covariant _PainBarsPainter old) =>
      old.progress != progress || old.values != values;
}

/// Jauge fine sur 5 (stress, fatigue, qualité de sommeil)
class RecapMeter extends StatelessWidget {
  final String emoji;
  final String label;
  final double? value;
  final Color color;

  const RecapMeter({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: v == null ? 0 : v / 5),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, t, _) => LinearProgressIndicator(
                  value: t,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              v == null ? '-' : v.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(color: WakyColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nombre qui s'anime de 0 à [value]
class CountUpText extends StatelessWidget {
  final num value;
  final TextStyle style;
  final int decimals;

  const CountUpText({
    super.key,
    required this.value,
    required this.style,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(v.toStringAsFixed(decimals), style: style),
    );
  }
}
