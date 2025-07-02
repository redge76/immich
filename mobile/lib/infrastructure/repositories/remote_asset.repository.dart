import 'package:drift/drift.dart';
import 'package:immich_mobile/domain/models/asset/base_asset.model.dart';
import 'package:immich_mobile/infrastructure/entities/exif.entity.drift.dart';
import 'package:immich_mobile/infrastructure/entities/remote_asset.entity.dart';
import 'package:immich_mobile/infrastructure/entities/remote_asset.entity.drift.dart';
import 'package:immich_mobile/infrastructure/repositories/db.repository.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class DriftRemoteAssetRepository extends DriftDatabaseRepository {
  final Drift _db;
  const DriftRemoteAssetRepository(this._db) : super(_db);

  Future<RemoteAsset?> get(String assetId) {
    final query = _db.remoteAssetEntity.select()
      ..where((asset) => asset.id.equals(assetId));

    return query.map((asset) => asset.toDto()).getSingleOrNull();
  }

  Future<void> updateFavorite(List<String> ids, bool isFavorite) {
    return _db.batch((batch) async {
      for (final id in ids) {
        batch.update(
          _db.remoteAssetEntity,
          RemoteAssetEntityCompanion(isFavorite: Value(isFavorite)),
          where: (e) => e.id.equals(id),
        );
      }
    });
  }

  Future<void> updateVisibility(List<String> ids, AssetVisibility visibility) {
    return _db.batch((batch) async {
      for (final id in ids) {
        batch.update(
          _db.remoteAssetEntity,
          RemoteAssetEntityCompanion(visibility: Value(visibility)),
          where: (e) => e.id.equals(id),
        );
      }
    });
  }

  Future<void> trash(List<String> ids) {
    return _db.batch((batch) async {
      for (final id in ids) {
        batch.update(
          _db.remoteAssetEntity,
          RemoteAssetEntityCompanion(deletedAt: Value(DateTime.now())),
          where: (e) => e.id.equals(id),
        );
      }
    });
  }

  Future<void> delete(List<String> ids) {
    return _db.remoteAssetEntity.deleteWhere((row) => row.id.isIn(ids));
  }

  Future<void> updateLocation(List<String> ids, LatLng location) {
    return _db.batch((batch) async {
      for (final id in ids) {
        batch.update(
          _db.remoteExifEntity,
          RemoteExifEntityCompanion(
            latitude: Value(location.latitude),
            longitude: Value(location.longitude),
          ),
          where: (e) => e.assetId.equals(id),
        );
      }
    });
  }

  Future<void> updateDateTime(List<String> ids, String dateTime) {
    final localDateTime =
        dateTime.replaceAll(RegExp(r'[\+|-][0-9]{2}:[0-9]{2}'), '');
    return _db.batch((batch) async {
      for (final id in ids) {
        batch.update(
          _db.remoteAssetEntity,
          RemoteAssetEntityCompanion(
            localDateTime: Value(DateTime.parse(localDateTime).toUtc()),
          ),
          where: (e) => e.id.equals(id),
        );
        batch.update(
          _db.remoteExifEntity,
          RemoteExifEntityCompanion(
            dateTimeOriginal: Value(DateTime.parse(dateTime)),
          ),
          where: (e) => e.assetId.equals(id),
        );
      }
    });
  }
}
