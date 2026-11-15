import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:waky_gut/core/services/collection_draw.dart';

void main() {
  final all = List.generate(50, (i) => '${i + 1}');

  double newRate(Set<String> discovered, {int draws = 20000}) {
    final random = Random(42);
    var news = 0;
    for (var i = 0; i < draws; i++) {
      final id = drawWithPity<String>(
        allItems: all,
        discoveredIds: discovered,
        idOf: (s) => s,
        random: random,
      );
      if (!discovered.contains(id)) news++;
    }
    return news / draws;
  }

  test('2 restants sur 50 : environ 50 % de nouveaux (et non 4 %)', () {
    final discovered = all.take(48).toSet();
    expect(newRate(discovered), closeTo(0.5, 0.02));
  });

  test('1 restant sur 50 : environ 50 % de nouveaux', () {
    final discovered = all.take(49).toSet();
    expect(newRate(discovered), closeTo(0.5, 0.02));
  });

  test('début de collection : probabilité naturelle conservée', () {
    final discovered = all.take(10).toSet(); // 40/50 = 80 %
    expect(newRate(discovered), closeTo(0.8, 0.02));
  });

  test('collection vide : tout est nouveau', () {
    expect(newRate(<String>{}), 1.0);
  });

  test('collection complète : aucun nouveau, pas de crash', () {
    expect(newRate(all.toSet(), draws: 100), 0.0);
  });
}
