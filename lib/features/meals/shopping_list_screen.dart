import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

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

  Widget _buildShoppingList(BuildContext context, List<String> foods) {
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: WakyColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: WakyColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    food,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, List<String> foods) {
    final text = foods.join('\n');
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liste copiée dans le presse-papiers'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
