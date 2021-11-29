import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class HistoricMapView extends StatefulWidget {
  const HistoricMapView({Key? key}) : super(key: key);

  @override
  State<HistoricMapView> createState() => _HistoricMapViewState();
}

class _HistoricMapViewState extends State<HistoricMapView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<HistoricProvider>(
          builder: (_, HistoricProvider provider, __) {
        final DeviceProvider deviceProvider =
            Provider.of<DeviceProvider>(context, listen: false);
        return GoogleMap(
          polylines: provider.line,
          zoomControlsEnabled: false,
          markers: provider.getMarker(),
          mapType: deviceProvider.mapType,
          onMapCreated: (controller) async {
            provider.googleMapController = controller;
            provider.controller.complete(controller);
            double zoom = await controller.getZoomLevel();
            controller.moveCamera(CameraUpdate.zoomTo(zoom + 0.1));
          },
          initialCameraPosition:
              const CameraPosition(target: LatLng(31.7917, -7.0926), zoom: 6),
        );
      }),
    );
  }
}
