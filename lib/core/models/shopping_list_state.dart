import 'package:isar/isar.dart';

part 'shopping_list_state.g.dart';

/// État persisté de la liste de courses
/// Sauvegarde les articles cochés entre les sessions
@collection
class ShoppingListItemState {
  Id id = Isar.autoIncrement;

  /// Nom de l'aliment
  @Index(unique: true)
  String foodName;

  /// True si l'aliment est marqué comme acheté
  bool isChecked;

  /// Date de dernière modification
  DateTime updatedAt;

  ShoppingListItemState({
    required this.foodName,
    this.isChecked = false,
  }) : updatedAt = DateTime.now();
}
