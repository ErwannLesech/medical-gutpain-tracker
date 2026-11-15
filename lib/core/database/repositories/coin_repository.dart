import 'package:isar/isar.dart';

import '../../models/coin_transaction.dart';
import '../database_service.dart';

/// Repository du registre des Catcoins
class CoinRepository {
  final DatabaseService _db;

  CoinRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  /// Ajoute un mouvement s'il n'existe pas déjà pour cette [refKey].
  /// Retourne true si le mouvement a été ajouté, false s'il existait déjà.
  Future<bool> addIfAbsent(CoinTransaction transaction) async {
    return _isar.writeTxn(() async {
      final existing =
          await _isar.coinTransactions.getByRefKey(transaction.refKey);
      if (existing != null) return false;
      await _isar.coinTransactions.put(transaction);
      return true;
    });
  }

  /// Dépense (montant négatif) seulement si le solde le permet.
  Future<bool> spendIfAffordable(CoinTransaction transaction) async {
    assert(transaction.amount < 0);
    return _isar.writeTxn(() async {
      final balance = await _isar.coinTransactions.where().amountProperty().sum();
      if (balance + transaction.amount < 0) return false;
      if (await _isar.coinTransactions.getByRefKey(transaction.refKey) != null) {
        return false;
      }
      await _isar.coinTransactions.put(transaction);
      return true;
    });
  }

  /// Vérifie si une récompense a déjà été versée pour cette clé
  Future<bool> hasRefKey(String refKey) async {
    return await _isar.coinTransactions.getByRefKey(refKey) != null;
  }

  /// Clés de tous les mouvements dont la clé commence par [prefix]
  Future<List<String>> refKeysWithPrefix(String prefix) async {
    return _isar.coinTransactions
        .filter()
        .refKeyStartsWith(prefix)
        .refKeyProperty()
        .findAll();
  }

  /// Solde actuel (somme de tous les mouvements)
  Future<int> getBalance() async {
    return _isar.coinTransactions.where().amountProperty().sum();
  }

  /// Total gagné (montants positifs) sur une période [start, end[
  Future<int> getEarnedBetween(DateTime start, DateTime end) async {
    final transactions = await _isar.coinTransactions
        .where()
        .createdAtBetween(start, end, includeUpper: false)
        .filter()
        .amountGreaterThan(0)
        .findAll();
    return transactions.fold<int>(0, (sum, t) => sum + t.amount);
  }

  /// Solde en temps réel
  Stream<int> watchBalance() {
    return _isar.coinTransactions
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getBalance());
  }
}
