import 'package:flutter/material.dart';

import '../../core/data/food_card_data.dart';
import '../../core/services/food_reward_service.dart';
import '../../features/home/achievements_screen.dart';
import '../theme/colors.dart';

/// Dialog affichant le resultat d'un tirage de carte de plat
class FoodCardDrawResultDialog extends StatefulWidget {
  final FoodCardDrawResult result;

  const FoodCardDrawResultDialog({
    super.key,
    required this.result,
  });

  /// Affiche le dialog de resultat de tirage
  /// Retourne true si l'utilisateur a cliqué "Voir ma galerie", false sinon
  static Future<bool> show(BuildContext context, FoodCardDrawResult result) async {
    final result_ = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FoodCardDrawResultDialog(result: result),
    );
    return result_ ?? false;
  }

  @override
  State<FoodCardDrawResultDialog> createState() => _FoodCardDrawResultDialogState();
}

class _FoodCardDrawResultDialogState extends State<FoodCardDrawResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _showFront = true;
  bool _hasFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= 0.5 && _showFront) {
        setState(() => _showFront = false);
      }
    });
  }

  void _flipCard() {
    if (_hasFlipped) return;
    setState(() => _hasFlipped = true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.result.isNewDiscovery;
    final card = widget.result.card;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.14159;
        final isFrontSide = angle < 3.14159 / 2;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: !_hasFlipped ? _flipCard : null,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFrontSide
                  ? _buildCardBack(context)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159),
                      child: _buildCardFront(context, card, isNew),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBack(BuildContext context) {
    return AlertDialog(
      backgroundColor: WakyColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: SizedBox(
        width: 250,
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_giftcard,
                size: 80,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 16),
              Text(
                '?',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Touche ici',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(BuildContext context, FoodCardData card, bool isNew) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPrestige = card.isPrestige;

    return Center(
      child: Container(
        width: screenWidth * 0.9,
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isNew ? const Color(0xFFFFF8E1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrestige ? WakyColors.gold : WakyColors.primary.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNew) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      WakyColors.sunshine,
                      WakyColors.gold.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: WakyColors.sunshine.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'NOUVELLE CARTE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Deja decouverte',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (isPrestige) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: WakyColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Carte prestige',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: WakyColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: isNew
                    ? Border.all(color: WakyColors.sunshine, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: (isNew ? WakyColors.sunshine : WakyColors.primary)
                        .withValues(alpha: isNew ? 0.4 : 0.2),
                    blurRadius: isNew ? 25 : 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  card.assetPath,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              card.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPrestige ? WakyColors.gold : WakyColors.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isNew ? WakyColors.sunshine.withValues(alpha: 0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isNew
                    ? 'Cette carte rejoint ta collection.'
                    : 'Tu avais deja cette carte. Continue a remplir ton journal pour en trouver d\'autres.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isNew ? WakyColors.sunshine : Colors.grey.shade700,
                      fontWeight: isNew ? FontWeight.w600 : FontWeight.normal,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Retourner true si l'utilisateur veut voir la galerie
                  if (isNew) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPrestige ? WakyColors.gold : WakyColors.sunshine,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isPrestige ? 4 : 2,
                ),
                child: Text(
                  isNew ? 'Voir ma galerie' : 'Super',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher un apercu de carte dans la galerie
class FoodCardGalleryItem extends StatelessWidget {
  final FoodCardData card;
  final bool isDiscovered;
  final VoidCallback? onTap;

  const FoodCardGalleryItem({
    super.key,
    required this.card,
    required this.isDiscovered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDiscovered ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDiscovered ? Colors.white : Colors.grey.shade200,
          boxShadow: isDiscovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: isDiscovered
                    ? Image.asset(
                        card.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(context);
                        },
                      )
                    : _buildLockedPlaceholder(context),
              ),
              if (isDiscovered)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                    child: Text(
                      card.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 32,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              '?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// Dialog pour afficher les details d'une carte decouverte
class FoodCardDetailDialog extends StatelessWidget {
  final FoodCardData card;
  final DateTime? discoveredAt;

  const FoodCardDetailDialog({
    super.key,
    required this.card,
    this.discoveredAt,
  });

  static Future<void> show(
    BuildContext context,
    FoodCardData card, {
    DateTime? discoveredAt,
  }) {
    return showDialog(
      context: context,
      builder: (context) => FoodCardDetailDialog(
        card: card,
        discoveredAt: discoveredAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              card.assetPath,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 220,
                  height: 220,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (card.isPrestige) ...[
            const SizedBox(height: 8),
            Text(
              'Carte prestige',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: WakyColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          if (discoveredAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Decouvert le ${_formatDate(discoveredAt!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
