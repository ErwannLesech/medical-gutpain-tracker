import 'dart:math';

/// Probabilité minimale d'obtenir un élément NOUVEAU lors d'un tirage,
/// tant que la collection n'est pas complète.
///
/// Avec un tirage uniforme, il ne reste que 2/50 = 4 % de chances de trouver
/// l'un des 2 derniers éléments. Ce plancher garantit qu'on a toujours au
/// moins 1 chance sur 2 d'avoir du nouveau, quelle que soit la progression.
const double minNewItemProbability = 0.5;

/// Tire un élément d'une collection en garantissant une probabilité minimale
/// d'obtenir un nouvel élément.
///
/// - Début de collection : la probabilité naturelle (restants / total) est
///   supérieure au plancher, elle est conservée (tirage identique à avant).
/// - Fin de collection : la probabilité de "nouveau" est relevée à
///   [minNewItemProbability] ; l'élément nouveau est tiré uniformément parmi
///   ceux qui restent à découvrir.
/// - Sinon (pas de "nouveau" tiré) : doublon tiré parmi les déjà découverts.
///
/// [discoveredIds] contient les identifiants déjà découverts.
T drawWithPity<T>({
  required List<T> allItems,
  required Set<String> discoveredIds,
  required String Function(T item) idOf,
  required Random random,
  double minNewProbability = minNewItemProbability,
}) {
  final undiscovered =
      allItems.where((i) => !discoveredIds.contains(idOf(i))).toList();
  final discovered =
      allItems.where((i) => discoveredIds.contains(idOf(i))).toList();

  // Collection complète (ou rien de découvert) : tirage uniforme classique.
  if (undiscovered.isEmpty) {
    return discovered[random.nextInt(discovered.length)];
  }
  if (discovered.isEmpty) {
    return undiscovered[random.nextInt(undiscovered.length)];
  }

  final naturalProbability = undiscovered.length / allItems.length;
  final newProbability = max(naturalProbability, minNewProbability);

  final pool = random.nextDouble() < newProbability ? undiscovered : discovered;
  return pool[random.nextInt(pool.length)];
}
