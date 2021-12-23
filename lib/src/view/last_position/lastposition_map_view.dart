import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class LastpositionMap extends StatefulWidget {
  const LastpositionMap({Key? key}) : super(key: key);

  @override
  State<LastpositionMap> createState() => _LastpositionMapState();
}

class _LastpositionMapState extends State<LastpositionMap> {
  @override
  Widget build(BuildContext context) {
    //super.build(context);

    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    LastPositionProvider p =
        Provider.of<LastPositionProvider>(context, listen: false);
    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 7), (_) async {
          return await p.fetch();
        }),
        builder: (context, snapshot) {
          LastPositionProvider provider =
              Provider.of<LastPositionProvider>(context);
          return GoogleMap(
            trafficEnabled: provider.traficClicked,
            mapType: deviceProvider.mapType,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: provider.enableZoomGesture,
            markers: provider.markersProvider.getMarkers(),
            polylines: provider.polylines,
            onTap: (_) {
              if (!provider.enableZoomGesture) {
                provider.enableZoomGesture = true;
              }
            },
            scrollGesturesEnabled: !provider.menuClicked,
            onMapCreated: (controller) async {
              provider.googleMapController = controller;
              if (!provider.controller.isCompleted) {
                provider.controller.complete(controller);
              }

              double zoom = await controller.getZoomLevel();
              controller.moveCamera(CameraUpdate.zoomTo(zoom + 0.1));

              provider.markersProvider.simpleMarkerManager
                  .setMapId(controller.mapId);
              provider.markersProvider.textMarkerManager
                  .setMapId(controller.mapId);
            },
            onCameraMove: (pos) {
              provider.markersProvider.currentZoom = pos.zoom;
              provider.markersProvider.simpleMarkerManager.onCameraMove(pos);
              provider.markersProvider.textMarkerManager.onCameraMove(pos);
            },
            onCameraIdle: () {
              provider.markersProvider.simpleMarkerManager.updateMap();
              provider.markersProvider.textMarkerManager.updateMap();
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(31.7917, -7.0926), zoom: 6.5),
          );
        });
  }
}
