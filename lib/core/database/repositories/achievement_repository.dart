import 'package:isar/isar.dart';

import '../../models/achievement.dart';
import '../database_service.dart';

/// Repository pour la gestion des achievements
class AchievementRepository {
  final DatabaseService _db;

  AchievementRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  // ==================== CREATE / UPDATE ====================

  /// Débloque un achievement
  Future<int> unlock(BadgeType badgeType) async {
    // Vérifie si déjà débloqué
    final existing = await getByType(badgeType);
    if (existing != null) {
      return existing.id;
    }

    final achievement = Achievement()
      ..badgeType = badgeType
      ..unlockedAt = DateTime.now()
      ..seen = false;

    return await _isar.writeTxn(() async {
      return await _isar.achievements.put(achievement);
    });
  }

  /// Marque un achievement comme vu
  Future<void> markAsSeen(int id) async {
    await _isar.writeTxn(() async {
      final achievement = await _isar.achievements.get(id);
      if (achievement != null) {
        achievement.seen = true;
        await _isar.achievements.put(achievement);
      }
    });
  }

  /// Marque tous les achievements comme vus
  Future<void> markAllAsSeen() async {
    await _isar.writeTxn(() async {
      final achievements = await _isar.achievements.where().findAll();
      for (final achievement in achievements) {
        achievement.seen = true;
        await _isar.achievements.put(achievement);
      }
    });
  }

  // ==================== READ ====================

  /// Récupère un achievement par type
  Future<Achievement?> getByType(BadgeType type) async {
    return await _isar.achievements
        .where()
        .filter()
        .badgeTypeEqualTo(type)
        .findFirst();
  }

  /// Récupère tous les achievements débloqués
  Future<List<Achievement>> getAll() async {
    return await _isar.achievements
        .where()
        .sortByUnlockedAtDesc()
        .findAll();
  }

  /// Récupère les achievements non vus
  Future<List<Achievement>> getUnseen() async {
    return await _isar.achievements
        .where()
        .filter()
        .seenEqualTo(false)
        .sortByUnlockedAt()
        .findAll();
  }

  /// Vérifie si un achievement est débloqué
  Future<bool> isUnlocked(BadgeType type) async {
    final achievement = await getByType(type);
    return achievement != null;
  }

  /// Compte le nombre d'achievements débloqués
  Future<int> countUnlocked() async {
    return await _isar.achievements.count();
  }

  /// Compte le nombre d'achievements non vus
  Future<int> countUnseen() async {
    return await _isar.achievements
        .where()
        .filter()
        .seenEqualTo(false)
        .count();
  }

  // ==================== DELETE ====================

  /// Supprime un achievement (pour tests)
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.achievements.delete(id);
    });
  }

  /// Supprime tous les achievements (pour reset)
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.achievements.clear();
    });
  }

  // ==================== WATCH ====================

  /// Stream de tous les achievements
  Stream<List<Achievement>> watchAll() {
    return _isar.achievements
        .where()
        .sortByUnlockedAtDesc()
        .watch(fireImmediately: true);
  }

  /// Stream des achievements non vus
  Stream<List<Achievement>> watchUnseen() {
    return _isar.achievements
        .where()
        .filter()
        .seenEqualTo(false)
        .watch(fireImmediately: true);
  }
}
