import 'package:isar/isar.dart';

import '../../models/coin_transaction.dart';
import '../../models/scene_piece.dart';
import '../database_service.dart';

/// Repository des pièces de scènes (puzzle 3D)
class ScenePieceRepository {
  final DatabaseService _db;

  ScenePieceRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Isar get _isar => _db.isar;

  Future<List<ScenePiece>> getForScene(String sceneId) {
    return _isar.scenePieces.where().sceneIdEqualTo(sceneId).findAll();
  }

  Future<bool> hasRefKey(String refKey) async {
    return await _isar.scenePieces.getByRefKey(refKey) != null;
  }

  /// Ajoute une pièce si sa [ScenePiece.refKey] n'existe pas encore.
  Future<bool> addIfAbsent(ScenePiece piece) {
    return _isar.writeTxn(() async {
      if (await _isar.scenePieces.getByRefKey(piece.refKey) != null) return false;
      await _isar.scenePieces.put(piece);
      return true;
    });
  }

  /// Achat atomique : débite les Catcoins et ajoute la pièce dans la même
  /// transaction. Retourne false si le solde est insuffisant.
  Future<bool> buy(ScenePiece piece, CoinTransaction payment) {
    assert(payment.amount < 0);
    return _isar.writeTxn(() async {
      final balance = await _isar.coinTransactions.where().amountProperty().sum();
      if (balance + payment.amount < 0) return false;
      if (await _isar.coinTransactions.getByRefKey(payment.refKey) != null) return false;
      await _isar.coinTransactions.put(payment);
      await _isar.scenePieces.put(piece);
      return true;
    });
  }

  /// Pose une pièce du tiroir sur un emplacement libre.
  /// Retourne false si la pièce est déjà posée ou l'emplacement occupé.
  Future<bool> place(int pieceId, String slotId) {
    return _isar.writeTxn(() async {
      final piece = await _isar.scenePieces.get(pieceId);
      if (piece == null || piece.slotId != null) return false;
      final occupied = await _isar.scenePieces
          .where()
          .sceneIdEqualTo(piece.sceneId)
          .filter()
          .slotIdEqualTo(slotId)
          .count();
      if (occupied > 0) return false;
      piece.slotId = slotId;
      await _isar.scenePieces.put(piece);
      return true;
    });
  }

  Stream<void> watchChanges() => _isar.scenePieces.watchLazy(fireImmediately: true);
}
