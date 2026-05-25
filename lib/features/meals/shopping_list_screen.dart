import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../shared/theme/colors.dart';
import 'shopping_list_provider.dart';

/// Écran de la liste de courses
class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  @override
  void initState() {
    super.initState();
    // Recharge la liste de courses lors de l'ouverture de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shoppingListProvider.notifier).loadShoppingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de courses'),
        actions: [
          if (shoppingListState.foods.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copier la liste',
              onPressed: () => _copyToClipboard(context, shoppingListState.foods),
            ),
        ],
      ),
      body: SafeArea(
        child: shoppingListState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : shoppingListState.foods.isEmpty
                ? _buildEmptyState(context)
                : _buildShoppingList(context, shoppingListState.foods),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Aucun aliment à acheter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des repas pour les jours à venir',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingList(BuildContext context, Map<String, int> foods) {
    return Column(
      children: [
        // En-tête avec info
        Container(
          padding: const EdgeInsets.all(16),
          color: WakyColors.primary.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: WakyColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Liste des aliments prévus dans vos repas à venir',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: WakyColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),

        // Compteur
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${foods.length} aliment${foods.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),

        // Liste des aliments
        Expanded(
          child: Consumer(builder: (context, ref, _) {
            final checkedItems = ref.watch(shoppingListProvider).checkedItems;
            
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final entry = foods.entries.toList()[index];
                final food = entry.key;
                final count = entry.value;
                final isChecked = checkedItems.contains(food);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: isChecked,
                      onChanged: (_) async {
                        await ref.read(shoppingListProvider.notifier).toggleCheckedItem(food);
                      },
                    ),
                    title: Text(
                      food,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                        color: isChecked ? Colors.grey : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (count > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: WakyColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '×$count',
                              style: TextStyle(
                                color: WakyColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.restaurant_menu,
                            color: WakyColors.primary,
                            size: 20,
                          ),
                          tooltip: 'Voir les repas',
                          onPressed: () => _showMealsDialog(context, ref, food),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await ref.read(shoppingListProvider.notifier).toggleCheckedItem(food);
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Future<void> _showMealsDialog(BuildContext context, WidgetRef ref, String food) async {
    final notifier = ref.read(shoppingListProvider.notifier);
    final meals = await notifier.getMealsForFood(food);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Repas contenant "$food"'),
        content: meals.isEmpty
            ? const Text('Aucun repas futur ne contient cet aliment.')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: meals.map((meal) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  meal.typeEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('EEE d MMM à HH:mm', 'fr_FR')
                                            .format(meal.plannedDateTime),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (meal.foods.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Aliments: ${meal.foods.join(", ")}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, Map<String, int> foods) {
    final text = foods.entries
        .map((entry) {
          final food = entry.key;
          final count = entry.value;
          return count > 1 ? '$food ×$count' : food;
        })
        .join('\n');
    
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liste copiée dans le presse-papiers'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
