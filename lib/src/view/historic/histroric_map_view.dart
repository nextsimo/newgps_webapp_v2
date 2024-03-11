import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class HistoricMapView extends StatefulWidget {
  const HistoricMapView({super.key});

  @override
  State<HistoricMapView> createState() => _HistoricMapViewState();
}

class _HistoricMapViewState extends State<HistoricMapView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoricProvider>(
        builder: (_, HistoricProvider provider, __) {
      final DeviceProvider deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
        debugPrint('provider.animateMarker.values.toSet() ${provider.markers.values.length}');
      return Animarker(
        isActiveTrip: true,
        useRotation: false,
        rippleRadius: 0.2,
        duration:
            Duration(milliseconds: provider.speedDuration.inMilliseconds ~/ 10),
        rippleDuration: const Duration(milliseconds: 500),
        shouldAnimateCamera: false,
        rippleColor: provider.getRippleColor(),
        mapId: Future<int>.value(provider.googleMapController?.mapId ?? 0),
        markers: provider.animateMarker.values.toSet(),
        child: GoogleMap(
          polylines: provider.getLines(),
          zoomControlsEnabled: false,
          markers: provider.getMarker(),
          mapType: deviceProvider.mapType,
          onMapCreated: (controller) async {
            provider.googleMapController = controller;
            double zoom = await controller.getZoomLevel();
            controller.moveCamera(CameraUpdate.zoomTo(zoom + 0.1));
            setState(() {});
          },
          initialCameraPosition:
              const CameraPosition(target: LatLng(31.7917, -7.0926), zoom: 6),
        ),
      );
    });
  }
}
