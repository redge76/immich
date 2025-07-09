import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class DriftMap extends ConsumerStatefulWidget {
  const DriftMap({super.key});

  @override
  ConsumerState<DriftMap> createState() => _DriftMapState();
}

class _DriftMapState extends ConsumerState<DriftMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMapCreated(MapLibreMapController controller) {

  }

  void onMapMoved() {

  }

  void onMapClicked(Point<double> point, LatLng _) {

  }

  void onStyleLoaded() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constraints) => SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              MapLibreMap(
                attributionButtonMargins: const Point(8, kToolbarHeight),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 0,
                ),
                trackCameraPosition: true,
                onMapCreated: onMapCreated,
                onCameraIdle: onMapMoved,
                onMapClick: onMapClicked,
                onStyleLoadedCallback: onStyleLoaded,
                tiltGesturesEnabled: false,
                dragEnabled: false,
                myLocationEnabled: false,
                attributionButtonPosition: AttributionButtonPosition.topRight,
                rotateGesturesEnabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
