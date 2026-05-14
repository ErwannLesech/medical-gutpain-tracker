import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/food_card_data.dart';
import '../database/repositories/discovered_food_card_repository.dart';
import '../models/discovered_food_card.dart';

/// Resultat d'un tirage de carte de plat
class FoodCardDrawResult {
  /// La carte tiree
  final FoodCardData card;

  /// Si c'est une nouvelle carte decouverte
  final bool isNewDiscovery;

  /// L'entree dans la base de donnees (si nouveau)
  final DiscoveredFoodCard? discoveredCard;

  const FoodCardDrawResult({
    required this.card,
    required this.isNewDiscovery,
    this.discoveredCard,
  });
}

/// Statistiques de la galerie de plats
class FoodCardGalleryStats {
  /// Nombre de cartes decouvertes
  final int discoveredCount;

  /// Nombre total de cartes
  final int totalCount;

  /// Pourcentage de completion
  double get percentage => totalCount > 0 ? (discoveredCount / totalCount) * 100 : 0;

  const FoodCardGalleryStats({
    required this.discoveredCount,
    required this.totalCount,
  });
}

/// Service de gestion des recompenses de plats (systeme collection)
class FoodRewardService {
  final DiscoveredFoodCardRepository _repository;
  final Random _random = Random();

  FoodRewardService({required DiscoveredFoodCardRepository repository})
      : _repository = repository;

  /// Effectue un tirage de carte pour une date donnee
  /// Retourne null si un tirage a deja ete effectue pour cette date
  Future<FoodCardDrawResult?> drawFoodCardForDate(DateTime date) async {
    if (await _repository.hasDrawnForDate(date)) {
      debugPrint('🍽️ Tirage deja effectue pour cette date: $date');
      return null;
    }

    final cardIndex = _random.nextInt(allFoodCards.length);
    final card = allFoodCards[cardIndex];

    debugPrint('🍽️ Tirage de la carte #${card.id} (${card.name})');

    final isAlreadyDiscovered = await _repository.getByFoodCardId(card.id) != null;
    DiscoveredFoodCard? newDiscoveredCard;

    if (!isAlreadyDiscovered) {
      newDiscoveredCard = await _repository.addDiscoveredCard(
        foodCardId: card.id,
        reportDate: date,
      );
      debugPrint('🎉 Nouvelle carte decouverte: ${card.name}');
    } else {
      debugPrint('🔄 Carte deja decouverte (doublon): ${card.name}');
    }

    await _repository.recordDraw(
      reportDate: date,
      foodCardId: card.id,
      wasDuplicate: isAlreadyDiscovered,
    );

    return FoodCardDrawResult(
      card: card,
      isNewDiscovery: !isAlreadyDiscovered,
      discoveredCard: newDiscoveredCard,
    );
  }

  /// Recupere la carte tiree pour une date donnee
  Future<FoodCardData?> getDrawnCardForDate(DateTime date) async {
    final record = await _repository.getDrawByDate(date);
    if (record == null) return null;

    return allFoodCards.firstWhere(
      (card) => card.id == record.drawnFoodCardId,
      orElse: () => allFoodCards.first,
    );
  }

  /// Verifie si un tirage peut etre effectue pour une date
  Future<bool> canDrawForDate(DateTime date) async {
    return !await _repository.hasDrawnForDate(date);
  }

  /// Recupere toutes les cartes avec leur etat de decouverte
  Future<List<FoodCardWithStatus>> getAllCardsWithStatus() async {
    final discoveredIds = await _repository.getDiscoveredFoodCardIds();

    return allFoodCards.map((card) {
      final isDiscovered = discoveredIds.contains(card.id);
      return FoodCardWithStatus(
        card: card,
        isDiscovered: isDiscovered,
      );
    }).toList();
  }

  /// Recupere les statistiques de la galerie
  Future<FoodCardGalleryStats> getGalleryStats() async {
    final discoveredCount = await _repository.getDiscoveredCount();
    return FoodCardGalleryStats(
      discoveredCount: discoveredCount,
      totalCount: allFoodCards.length,
    );
  }

  /// Recupere les cartes decouvertes avec leur date de decouverte
  Future<List<DiscoveredFoodCardWithData>> getDiscoveredCardsWithData() async {
    final discovered = await _repository.getAllDiscovered();

    return discovered.map((dc) {
      final cardData = allFoodCards.firstWhere(
        (card) => card.id == dc.foodCardId,
        orElse: () => allFoodCards.first,
      );
      return DiscoveredFoodCardWithData(
        discoveredCard: dc,
        cardData: cardData,
      );
    }).toList();
  }

  /// Stream des statistiques
  Stream<FoodCardGalleryStats> watchGalleryStats() {
    return _repository.watchDiscoveredCount().map((count) {
      return FoodCardGalleryStats(
        discoveredCount: count,
        totalCount: allFoodCards.length,
      );
    });
  }
}

/// Carte avec son etat de decouverte
class FoodCardWithStatus {
  final FoodCardData card;
  final bool isDiscovered;

  const FoodCardWithStatus({
    required this.card,
    required this.isDiscovered,
  });
}

/// Carte decouverte avec ses donnees completes
class DiscoveredFoodCardWithData {
  final DiscoveredFoodCard discoveredCard;
  final FoodCardData cardData;

  const DiscoveredFoodCardWithData({
    required this.discoveredCard,
    required this.cardData,
  });
}
