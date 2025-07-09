import 'package:immich_mobile/domain/models/map.model.dart';
import 'package:immich_mobile/infrastructure/repositories/map.repository.dart';

typedef MapMarkerSource = Stream<List<Marker>> Function();

class MapFactory {
  final DriftMapRepository _mapRepository;

  const MapFactory({
    required DriftMapRepository mapRepository,
  })  : _mapRepository = mapRepository;

  MapService main(List<String> timelineUsers) => MapService(
        markerSource: () => _mapRepository.watchMainMarker(timelineUsers),
      );

  MapService remoteAlbum({required String albumId}) => MapService(
        markerSource: () => _mapRepository.watchRemoteAlbumMarker(albumId),
      );
}

class MapService {
  final MapMarkerSource _markerSource;

  MapService({
    required MapMarkerSource markerSource,
  })  : _markerSource = markerSource;

  Stream<List<Marker>> Function() get watchMarkers => _markerSource;

  Future<void> dispose() async {

  }
}
