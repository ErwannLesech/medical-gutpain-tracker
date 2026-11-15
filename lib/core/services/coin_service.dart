import '../database/repositories/coin_repository.dart';
import '../models/coin_transaction.dart';

/// Barème des Catcoins : on n'en gagne qu'avec les doublons du journal,
/// et on les dépense en indices ou en pièces de scène choisies.
class CoinRewards {
  CoinRewards._();

  /// Nom affiché de la monnaie
  static const String currencyName = 'Catcoins';

  /// Doublon de chat ou de plat tiré par le journal
  static const int duplicateCard = 1;

  /// Doublon de pièce de scène : la moitié (arrondie au-dessus) de son prix
  static int sceneDuplicate(int piecePrice) => (piecePrice + 1) ~/ 2;

  /// Prix d'un indice dans le puzzle des scènes (gratuit après 3 erreurs)
  static const int sceneHint = 1;

  /// Ancienneté max d'un journal pour gagner une pièce (évite de "farmer"
  /// en créant de vieux journaux)
  static const int dailyJournalMaxAgeDays = 7;
}

/// Service de gestion des Catcoins
class CoinService {
  final CoinRepository _coinRepo;

  CoinService({required CoinRepository coinRepo}) : _coinRepo = coinRepo;

  static String _day(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _month(int year, int month) =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';

  static String recapRefKey(int year, int month) =>
      'recap:${_month(year, month)}';

  static String dayKey(DateTime d) => _day(d);

  static String duplicateRefKey(String collection, DateTime reportDate) =>
      'dup:$collection:${_day(reportDate)}';

  /// Ancienneté (en jours) d'un journal par rapport à aujourd'hui
  static int journalAgeDays(DateTime reportDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    return DateTime(today.year, today.month, today.day)
        .difference(DateTime(reportDate.year, reportDate.month, reportDate.day))
        .inDays;
  }

  Future<int> getBalance() => _coinRepo.getBalance();

  Stream<int> watchBalance() => _coinRepo.watchBalance();

  Future<int> getEarnedBetween(DateTime start, DateTime end) =>
      _coinRepo.getEarnedBetween(start, end);

  Future<bool> hasRefKey(String refKey) => _coinRepo.hasRefKey(refKey);

  Future<int> _record(CoinReason reason, int amount, String refKey) async {
    final added = await _coinRepo.addIfAbsent(
      CoinTransaction(
        amount: amount,
        reason: reason,
        refKey: refKey,
        createdAt: DateTime.now(),
      ),
    );
    return added ? amount : 0;
  }

  /// Transforme un doublon en pièces ([collection] = "cat", "food" ou "scene").
  /// Une seule fois par collection et par date de journal.
  Future<int> awardDuplicate(
    String collection,
    DateTime reportDate, {
    int amount = CoinRewards.duplicateCard,
  }) {
    return _record(
      CoinReason.duplicateCard,
      amount,
      duplicateRefKey(collection, reportDate),
    );
  }

  /// Dépense [amount] Catcoins si le solde le permet.
  Future<bool> spend(int amount, String refKey) {
    return _coinRepo.spendIfAffordable(
      CoinTransaction(
        amount: -amount,
        reason: CoinReason.purchase,
        refKey: refKey,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Le bilan de ce mois a-t-il déjà été consulté jusqu'au bout ?
  Future<bool> isRecapSeen(int year, int month) =>
      _coinRepo.hasRefKey(recapRefKey(year, month));

  /// Marque le bilan comme vu (mouvement à 0 : le bilan ne rapporte rien,
  /// le registre sert seulement de trace)
  Future<void> markRecapSeen(int year, int month) async {
    await _record(CoinReason.monthlyRecap, 0, recapRefKey(year, month));
  }
}
