import 'package:drift/drift.dart';
import 'package:immich_mobile/domain/models/map.model.dart';
import 'package:immich_mobile/infrastructure/entities/exif.entity.drift.dart';
import 'package:immich_mobile/infrastructure/repositories/db.repository.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class DriftMapRepository extends DriftDatabaseRepository {
  final Drift _db;

  const DriftMapRepository(super._db) : _db = _db;

  Stream<List<Marker>> watchMainMarker(
    List<String> userIds,
  ) {
    final query = _db.remoteExifEntity.select()
      ..where((row) =>
          row.latitude.isNotNull() & row.longitude.isNotNull(),
      );

    return query
        .map((row) => row.toMarker())
        .watch();
  }

  Stream<List<Marker>> watchRemoteAlbumMarker(
    String albumId,
  ) {
    final query = _db.remoteExifEntity.select().join(
      [
        innerJoin(
          _db.remoteAssetEntity,
          _db.remoteAssetEntity.id.equalsExp(_db.remoteExifEntity.assetId),
          useColumns: false,
        ),
        leftOuterJoin(
          _db.remoteAlbumAssetEntity,
          _db.remoteAlbumAssetEntity.assetId.equalsExp(_db.remoteAssetEntity.id),
          useColumns: false,
        ),
      ]
    )
      ..where(
        _db.remoteExifEntity.latitude.isNotNull() &
            _db.remoteExifEntity.longitude.isNotNull() &
            _db.remoteAlbumAssetEntity.albumId.equals(albumId),
      );

    return query
        .map((row) => row.readTable(_db.remoteExifEntity).toMarker())
        .watch();
  }
}

extension on RemoteExifEntityData {
  Marker toMarker() {
    return Marker(
        assetId: assetId,
        location: LatLng(latitude!, longitude!),
      );
  }
}
