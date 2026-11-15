import 'package:waky_gut/core/database/repositories/repositories.dart';
import 'package:waky_gut/core/models/models.dart';

/// Registre de Catcoins en mémoire (mêmes règles que la version Isar)
class MemoryCoinRepository extends CoinRepository {
  final Map<String, CoinTransaction> ledger = {};

  @override
  Future<bool> addIfAbsent(CoinTransaction transaction) async {
    if (ledger.containsKey(transaction.refKey)) return false;
    ledger[transaction.refKey] = transaction;
    return true;
  }

  @override
  Future<bool> spendIfAffordable(CoinTransaction transaction) async {
    if (await getBalance() + transaction.amount < 0) return false;
    return addIfAbsent(transaction);
  }

  @override
  Future<bool> hasRefKey(String refKey) async => ledger.containsKey(refKey);

  @override
  Future<List<String>> refKeysWithPrefix(String prefix) async =>
      ledger.keys.where((k) => k.startsWith(prefix)).toList();

  @override
  Future<int> getBalance() async =>
      ledger.values.fold<int>(0, (sum, t) => sum + t.amount);
}
