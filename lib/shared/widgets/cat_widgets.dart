import 'package:flutter/material.dart';

import '../../core/data/cat_data.dart';
import '../../core/services/cat_reward_service.dart';
import '../../features/home/achievements_screen.dart';
import '../theme/colors.dart';

/// Dialog affichant le résultat d'un tirage de chat
class CatDrawResultDialog extends StatefulWidget {
  final CatDrawResult result;

  const CatDrawResultDialog({
    super.key,
    required this.result,
  });

  /// Affiche le dialog de résultat de tirage
  static Future<void> show(BuildContext context, CatDrawResult result) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CatDrawResultDialog(result: result),
    );
  }

  @override
  State<CatDrawResultDialog> createState() => _CatDrawResultDialogState();
}

class _CatDrawResultDialogState extends State<CatDrawResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool _showFront = true;
  bool _hasFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animation de retournement (0 à 1)
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Animation d'échelle pour l'effet "pop"
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);

    _flipAnimation.addListener(() {
      // Retourner la carte à mi-chemin
      if (_flipAnimation.value >= 0.5 && _showFront) {
        setState(() => _showFront = false);
      }
    });

    // Ne PAS démarrer l'animation automatiquement
  }

  void _flipCard() {
    if (_hasFlipped) return; // Empêcher de retourner plusieurs fois
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
    final cat = widget.result.cat;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculer l'angle de rotation
        final angle = _flipAnimation.value * 3.14159;
        // Déterminer si on est dans la moitié arrière de l'animation
        final isFrontSide = angle < 3.14159 / 2;
        
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: !_hasFlipped ? _flipCard : null,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle),
              child: isFrontSide 
                ? _buildCardBack(context)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159), // Inverser horizontalement pour rendre lisible
                    child: _buildCardFront(context, cat, isNew),
                  ),
            ),
          ),
        );
      },
    );
  }

  /// Dos de la carte (affiché au début)
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

  /// Face de la carte (révélée après le retournement)
  Widget _buildCardFront(BuildContext context, CatData cat, bool isNew) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: screenWidth * 0.9, // 90% de la largeur de l'écran
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isNew ? const Color(0xFFF0FFF4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isNew ? WakyColors.success : WakyColors.primary.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Badge "Nouveau" avec étoiles
          if (isNew) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WakyColors.success,
                    WakyColors.success.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: WakyColors.success.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    'NOUVELLE DÉCOUVERTE',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Text('⭐', style: TextStyle(fontSize: 16)),
                ],
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
                    'Déjà découvert',
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

          // Image du chat avec bordure spéciale si nouveau
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isNew
                  ? Border.all(color: WakyColors.success, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: (isNew ? WakyColors.success : WakyColors.primary)
                      .withValues(alpha: isNew ? 0.4 : 0.2),
                  blurRadius: isNew ? 25 : 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    cat.assetPath,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.pets,
                          size: 80,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Effet de brillance pour nouveau chat
                  if (isNew)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nom du chat
          Text(
            cat.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isNew ? WakyColors.success : WakyColors.primary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Message personnalisé
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isNew
                  ? WakyColors.success.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isNew
                  ? '✨ Ce magnifique chat rejoint ta collection ! Continue à remplir ton journal pour en découvrir d\'autres. ✨'
                  : '💭 Tu avais déjà découvert ce chat. Continue à remplir ton journal quotidiennement pour en trouver de nouveaux !',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isNew ? WakyColors.success : Colors.grey.shade700,
                    fontWeight: isNew ? FontWeight.w600 : FontWeight.normal,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Bouton fermer
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Fermer le dialog d'abord
                Navigator.of(context).pop();
                // Naviguer vers la galerie de chats après un court délai
                if (isNew) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AchievementsScreen(),
                        ),
                      );
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isNew ? WakyColors.success : WakyColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isNew ? 4 : 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isNew) const Text('⭐ ', style: TextStyle(fontSize: 18)),
                  Text(
                    isNew ? 'Voir ma galerie' : 'Super !',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isNew) const Text(' ⭐', style: TextStyle(fontSize: 18)),
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

/// Widget pour afficher un aperçu de chat dans la galerie
class CatGalleryItem extends StatelessWidget {
  final CatData cat;
  final bool isDiscovered;
  final VoidCallback? onTap;

  const CatGalleryItem({
    super.key,
    required this.cat,
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
          child: isDiscovered
              ? Image.asset(
                  cat.assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder(context);
                  },
                )
              : _buildLockedPlaceholder(context),
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
          Icons.pets,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// Dialog pour afficher les détails d'un chat découvert
class CatDetailDialog extends StatelessWidget {
  final CatData cat;
  final DateTime? discoveredAt;

  const CatDetailDialog({
    super.key,
    required this.cat,
    this.discoveredAt,
  });

  static Future<void> show(
    BuildContext context,
    CatData cat, {
    DateTime? discoveredAt,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CatDetailDialog(
        cat: cat,
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
          // Image du chat
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              cat.assetPath,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 220,
                  height: 220,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Nom du chat
          Text(
            cat.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          if (discoveredAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Découvert le ${_formatDate(discoveredAt!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],

          const SizedBox(height: 20),

          // Bouton fermer
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
