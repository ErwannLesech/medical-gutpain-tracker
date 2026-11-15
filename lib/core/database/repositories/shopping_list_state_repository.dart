import 'package:isar/isar.dart';

import '../../models/shopping_list_state.dart';
import '../database_service.dart';

/// Repository pour gérer l'état persisté de la liste de courses
class ShoppingListStateRepository {
  final DatabaseService _db;

  ShoppingListStateRepository({DatabaseService? db})
      : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE ====================

  /// Crée ou met à jour un article coché
  Future<int> saveCheckedItem(String foodName, bool isChecked) async {
    final item = ShoppingListItemState(
      foodName: foodName,
      isChecked: isChecked,
    );
    item.updatedAt = DateTime.now();

    return await _isar.writeTxn(() async {
      return await _isar.shoppingListItemStates.put(item);
    });
  }

  // ==================== READ ====================

  /// Récupère un article par son nom
  Future<ShoppingListItemState?> getByFoodName(String foodName) async {
    return await _isar.shoppingListItemStates
        .where()
        .filter()
        .foodNameEqualTo(foodName)
        .findFirst();
  }

  /// Récupère tous les articles cochés
  Future<List<String>> getCheckedItems() async {
    final items = await _isar.shoppingListItemStates
        .where()
        .filter()
        .isCheckedEqualTo(true)
        .findAll();
    return items.map((item) => item.foodName).toList();
  }

  /// Récupère tous les articles
  Future<List<ShoppingListItemState>> getAll() async {
    return await _isar.shoppingListItemStates.where().findAll();
  }

  // ==================== UPDATE ====================

  /// Met à jour l'état coché d'un article
  Future<int> updateCheckedState(String foodName, bool isChecked) async {
    final existing = await getByFoodName(foodName);
    if (existing != null) {
      existing.isChecked = isChecked;
      existing.updatedAt = DateTime.now();
      return await _isar.writeTxn(() async {
        return await _isar.shoppingListItemStates.put(existing);
      });
    } else {
      return await saveCheckedItem(foodName, isChecked);
    }
  }

  // ==================== DELETE ====================

  /// Supprime un article coché
  Future<bool> deleteByFoodName(String foodName) async {
    final item = await getByFoodName(foodName);
    if (item != null) {
      return await _isar.writeTxn(() async {
        return await _isar.shoppingListItemStates.delete(item.id);
      });
    }
    return false;
  }

  /// Supprime tous les articles cochés
  Future<int> deleteAllCheckedItems() async {
    return await _isar.writeTxn(() async {
      final items = await _isar.shoppingListItemStates
          .where()
          .filter()
          .isCheckedEqualTo(true)
          .findAll();
      return await _isar.shoppingListItemStates.deleteAll(
        items.map((item) => item.id).toList(),
      );
    });
  }

  /// Supprime tous les articles
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.shoppingListItemStates.clear();
    });
  }

  // ==================== CLEANUP ====================

  /// Nettoie les articles qui n'existent plus dans la liste active
  /// (aliments qui ne sont plus dans les repas futurs)
  Future<void> cleanupOldItems(List<String> activeFoods) async {
    final allItems = await getAll();
    final itemsToDelete = allItems
        .where((item) => !activeFoods.contains(item.foodName))
        .map((item) => item.id)
        .toList();

    if (itemsToDelete.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.shoppingListItemStates.deleteAll(itemsToDelete);
      });
    }
  }
}
