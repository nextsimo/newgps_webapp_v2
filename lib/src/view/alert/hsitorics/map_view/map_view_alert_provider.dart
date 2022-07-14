import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/device.dart';

import '../../../../utils/device_size.dart';
import '../../../../widgets/floatin_window.dart';

class MapViewAlertProvider with ChangeNotifier {
  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  set markers(Set<Marker> markers) {
    _markers = markers;
    notifyListeners();
  }

  MapViewAlertProvider(Device device) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchMarkers(device);
    });
  }

  void fetchMarkers(Device device) {
    markers.clear();
    markers.add(_getSimpleMarker(device));
    notifyListeners();
  }

  Marker _getSimpleMarker(Device device) {
    LatLng position = LatLng(device.latitude, device.longitude);
    Uint8List imgRes = base64Decode(device.markerPng);
/*     Uint8List imgRes = showMatricule
        ? base64Decode(device.markerTextPng)
        : base64Decode(device.markerPng); */
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(imgRes);
    return Marker(
      onTap: () => _onTapMarker(device),
      markerId: MarkerId('${device.latitude},${device.longitude}'),
      position: position,
      icon: bitmapDescriptor,
    );
  }

  Future<void> _onTapMarker(Device device) async {
    await showModalBottomSheet(
      isDismissible: true,
      context: DeviceSize.c,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: false,
      builder: (context) {
        return FloatingGroupWindowInfo(
          showCallDriver: true,
          onClose: () {},
          device: device,
          showOnOffDevice: false,
        );
      },
    );
  }
}
