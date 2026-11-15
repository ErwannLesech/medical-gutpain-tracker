import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/coin_service.dart';
import '../../core/services/providers.dart';

/// Pièce "Catcoin" : pièce dorée avec une tête de chat en relief
class CatCoinIcon extends StatelessWidget {
  final double size;

  const CatCoinIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: CoinRewards.currencyName,
      child: CustomPaint(
        size: Size.square(size),
        painter: _CatCoinPainter(),
      ),
    );
  }
}

class _CatCoinPainter extends CustomPainter {
  static const _rim = Color(0xFFE0A100);
  static const _face = Color(0xFFFFD54F);
  static const _shine = Color(0xFFFFF3C4);
  static const _emboss = Color(0xFFB07A00);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);

    // Bord et face de la pièce
    canvas.drawCircle(c, s / 2, Paint()..color = _rim);
    canvas.drawCircle(
      c,
      s * 0.42,
      Paint()
        ..shader = const RadialGradient(
          colors: [_shine, _face],
          center: Alignment(-0.4, -0.5),
          radius: 0.9,
        ).createShader(Rect.fromCircle(center: c, radius: s * 0.42)),
    );

    final emboss = Paint()..color = _emboss;

    // Tête de chat : oreilles + visage
    final head = Offset(c.dx, c.dy + s * 0.04);
    final headR = s * 0.21;
    Path ear(double dir) => Path()
      ..moveTo(head.dx + dir * headR * 0.95, head.dy - headR * 0.25)
      ..lineTo(head.dx + dir * headR * 0.85, head.dy - headR * 1.45)
      ..lineTo(head.dx + dir * headR * 0.15, head.dy - headR * 0.85)
      ..close();
    canvas.drawPath(ear(-1), emboss);
    canvas.drawPath(ear(1), emboss);
    canvas.drawOval(
      Rect.fromCenter(center: head, width: headR * 2.1, height: headR * 1.8),
      emboss,
    );

    // Yeux + nez (couleur de la face, pour l'effet gravé)
    final facePaint = Paint()..color = _face;
    final eyeY = head.dy - headR * 0.1;
    canvas.drawCircle(Offset(head.dx - headR * 0.42, eyeY), headR * 0.16, facePaint);
    canvas.drawCircle(Offset(head.dx + headR * 0.42, eyeY), headR * 0.16, facePaint);
    final nose = Path()
      ..moveTo(head.dx - headR * 0.14, head.dy + headR * 0.22)
      ..lineTo(head.dx + headR * 0.14, head.dy + headR * 0.22)
      ..lineTo(head.dx, head.dy + headR * 0.38)
      ..close();
    canvas.drawPath(nose, facePaint);

    // Moustaches (seulement si la pièce est assez grande pour les voir)
    if (s >= 28) {
      final whisker = Paint()
        ..color = _emboss
        ..strokeWidth = max(1, s * 0.025)
        ..strokeCap = StrokeCap.round;
      for (final dir in [-1.0, 1.0]) {
        for (final dy in [-0.06, 0.08]) {
          canvas.drawLine(
            Offset(head.dx + dir * headR * 1.05, head.dy + headR * (0.3 + dy)),
            Offset(head.dx + dir * headR * 1.6, head.dy + headR * (0.22 + dy * 2)),
            whisker,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pastille affichant le solde de Catcoins
class CoinBalanceChip extends ConsumerWidget {
  const CoinBalanceChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(coinBalanceProvider).valueOrNull;

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CatCoinIcon(size: 24),
          const SizedBox(width: 6),
          Text(
            balance?.toString() ?? '-',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF8A5A00),
            ),
          ),
        ],
      ),
    );
  }
}

/// Texte "+N [pièce]" pour annoncer un gain
class CoinGainLabel extends StatelessWidget {
  final int amount;
  final double iconSize;
  final TextStyle? style;

  const CoinGainLabel({
    super.key,
    required this.amount,
    this.iconSize = 18,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('+$amount ', style: style ?? const TextStyle(fontWeight: FontWeight.bold)),
        CatCoinIcon(size: iconSize),
      ],
    );
  }
}
