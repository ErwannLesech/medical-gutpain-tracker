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
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

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
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Titre
                  Text(
                    isNew ? '🎉 Nouveau chat découvert !' : '🐱 Chat du jour',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isNew ? WakyColors.success : WakyColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Image du chat
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isNew ? WakyColors.success : WakyColors.primary)
                              .withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
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

                  const SizedBox(height: 8),

                  // Message
                  Text(
                    isNew
                        ? 'Ce chat a été ajouté à ta collection !'
                        : 'Tu avais déjà découvert ce chat.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Bouton fermer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Redirection vers la page des badges et galerie
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AchievementsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isNew ? WakyColors.success : WakyColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isNew ? 'Voir ma galerie' : 'Super !',
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
          ),
        );
      },
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
