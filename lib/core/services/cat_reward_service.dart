import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/cat_data.dart';
import '../database/repositories/discovered_cat_repository.dart';
import '../models/discovered_cat.dart';

/// Résultat d'un tirage de chat
class CatDrawResult {
  /// Le chat tiré
  final CatData cat;

  /// Si c'est un nouveau chat découvert
  final bool isNewDiscovery;

  /// L'entrée dans la base de données (si nouveau)
  final DiscoveredCat? discoveredCat;

  const CatDrawResult({
    required this.cat,
    required this.isNewDiscovery,
    this.discoveredCat,
  });
}

/// Statistiques de la galerie de chats
class CatGalleryStats {
  /// Nombre de chats découverts
  final int discoveredCount;

  /// Nombre total de chats
  final int totalCount;

  /// Pourcentage de complétion
  double get percentage => totalCount > 0 ? (discoveredCount / totalCount) * 100 : 0;

  const CatGalleryStats({
    required this.discoveredCount,
    required this.totalCount,
  });
}

/// Service de gestion des récompenses de chats (système Pokédex)
class CatRewardService {
  final DiscoveredCatRepository _repository;
  final Random _random = Random();

  CatRewardService({required DiscoveredCatRepository repository})
      : _repository = repository;

  /// Effectue un tirage de chat pour une date donnée
  /// Retourne null si un tirage a déjà été effectué pour cette date
  Future<CatDrawResult?> drawCatForDate(DateTime date) async {
    if (await isCollectionComplete()) {
      debugPrint('🐱 Collection completee, tirage bloque.');
      return null;
    }

    // Vérifie si un tirage a déjà été effectué pour cette date
    if (await _repository.hasDrawnForDate(date)) {
      debugPrint('🐱 Tirage déjà effectué pour cette date: $date');
      return null;
    }

    // Tirage aléatoire d'un chat
    final catIndex = _random.nextInt(allCats.length);
    final cat = allCats[catIndex];

    debugPrint('🐱 Tirage du chat #${cat.id} (${cat.name})');

    // Vérifie si le chat est déjà découvert
    final isAlreadyDiscovered = await _repository.getByCatId(cat.id) != null;
    DiscoveredCat? newDiscoveredCat;

    if (!isAlreadyDiscovered) {
      // Nouveau chat découvert !
      newDiscoveredCat = await _repository.addDiscoveredCat(
        catId: cat.id,
        reportDate: date,
      );
      debugPrint('🎉 Nouveau chat découvert: ${cat.name}');
    } else {
      debugPrint('🔄 Chat déjà découvert (doublon): ${cat.name}');
    }

    // Enregistre le tirage
    await _repository.recordDraw(
      reportDate: date,
      catId: cat.id,
      wasDuplicate: isAlreadyDiscovered,
    );

    return CatDrawResult(
      cat: cat,
      isNewDiscovery: !isAlreadyDiscovered,
      discoveredCat: newDiscoveredCat,
    );
  }

  /// Récupère le tirage effectué pour une date donnée
  Future<CatData?> getDrawnCatForDate(DateTime date) async {
    final record = await _repository.getDrawByDate(date);
    if (record == null) return null;

    return allCats.firstWhere(
      (cat) => cat.id == record.drawnCatId,
      orElse: () => allCats.first,
    );
  }

  /// Vérifie si un tirage peut être effectué pour une date
  Future<bool> canDrawForDate(DateTime date) async {
    if (await isCollectionComplete()) {
      return false;
    }

    return !await _repository.hasDrawnForDate(date);
  }

  /// Verifie si la collection est completee
  Future<bool> isCollectionComplete() async {
    final discoveredCount = await _repository.getDiscoveredCount();
    return discoveredCount >= allCats.length;
  }

  /// Récupère tous les chats avec leur état de découverte
  Future<List<CatWithStatus>> getAllCatsWithStatus() async {
    final discoveredIds = await _repository.getDiscoveredCatIds();

    return allCats.map((cat) {
      final isDiscovered = discoveredIds.contains(cat.id);
      return CatWithStatus(
        cat: cat,
        isDiscovered: isDiscovered,
      );
    }).toList();
  }

  /// Récupère les statistiques de la galerie
  Future<CatGalleryStats> getGalleryStats() async {
    final discoveredCount = await _repository.getDiscoveredCount();
    return CatGalleryStats(
      discoveredCount: discoveredCount,
      totalCount: allCats.length,
    );
  }

  /// Récupère les chats découverts avec leur date de découverte
  Future<List<DiscoveredCatWithData>> getDiscoveredCatsWithData() async {
    final discovered = await _repository.getAllDiscovered();
    
    return discovered.map((dc) {
      final catData = allCats.firstWhere(
        (cat) => cat.id == dc.catId,
        orElse: () => allCats.first,
      );
      return DiscoveredCatWithData(
        discoveredCat: dc,
        catData: catData,
      );
    }).toList();
  }

  /// Stream des statistiques
  Stream<CatGalleryStats> watchGalleryStats() {
    return _repository.watchDiscoveredCount().map((count) {
      return CatGalleryStats(
        discoveredCount: count,
        totalCount: allCats.length,
      );
    });
  }
}

/// Chat avec son état de découverte
class CatWithStatus {
  final CatData cat;
  final bool isDiscovered;

  const CatWithStatus({
    required this.cat,
    required this.isDiscovered,
  });
}

/// Chat découvert avec ses données complètes
class DiscoveredCatWithData {
  final DiscoveredCat discoveredCat;
  final CatData catData;

  const DiscoveredCatWithData({
    required this.discoveredCat,
    required this.catData,
  });
}
