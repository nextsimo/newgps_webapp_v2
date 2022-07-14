import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/info_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/view/last_position/markers_provider.dart';

class LastPositionProvider with ChangeNotifier {
  late Set<Polyline> polylines = {};
  late DateTime lastDateFetchDevices = DateTime.now();
  late bool notifyMap = false;
  late bool _menuClicked = false;

  bool _init = false;

  late MarkersProvider markersProvider;

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  bool _matriculeClicked = false;
  bool _regrouperClicked = false;

  bool get regrouperClicked => _regrouperClicked;

  set regrouperClicked(bool regrouperClicked) {
    _regrouperClicked = regrouperClicked;
    notifyListeners();
  }

  Future<void> fetch() async {
    if (markersProvider.fetchGroupesDevices) {
      await fetchDevices();
    } else {
      await fetchDevice(deviceProvider.selectedDevice.deviceId);
    }
  }

  bool get matriculeClicked => _matriculeClicked;

  set matriculeClicked(bool matriculeClicked) {
    _matriculeClicked = matriculeClicked;
    notifyListeners();
  }

  bool _traficClicked = false;

  bool get traficClicked => _traficClicked;

  void ontraficClicked(bool newState) {
    _traficClicked = newState;
    notifyListeners();
  }

  Future<void> fetchInfoData() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/info',
      body: {
        'account_id': account?.account.accountId,
        'device_id': deviceProvider.selectedDevice.deviceId
      },
    );
    if (res.isNotEmpty) {
      deviceProvider.infoModel = infoModelFromJson(res);
    }
  }

  void normaleView() {
    googleMapController!.animateCamera(CameraUpdate.zoomTo(6));
  }

  bool get menuClicked => _menuClicked;

  void menuIsClicked(bool menuClicked) async {
    _menuClicked = menuClicked;
  }

  void notifyTheMap() {
    notifyMap = !notifyMap;
    notifyListeners();
  }

  Future<void> onClickRegoupement(bool state) async {
    regrouperClicked = state;
    //log("$state");
    await markersProvider.onClickGroupment(state, deviceProvider.devices);
    notifyListeners();
  }

  Future<void> onClickMatricule(bool state) async {
    matriculeClicked = state;
    //log("$state");
    await markersProvider.onClickMatricule(state, deviceProvider.devices);
    notifyListeners();
  }

  GoogleMapController? googleMapController;

  TextEditingController autoSearchController =
      TextEditingController(text: 'Touts les véhicules');
  void fresh() {
    deviceProvider.devices = [];
    polylines = {};
    markersProvider.fetchGroupesDevices = true;
    lastDateFetchDevices = DateTime.now();
    notifyMap = false;
    googleMapController = null;
    markersProvider.clusterItems = [];
    markersProvider.clusterItemsText = [];
    markersProvider.clusterMarkers = {};
    markersProvider.onMarker = {};
    markersProvider.showMatricule = false;
    markersProvider.showCluster = false;
    markersProvider.devices = [];
    markersProvider.textMakers = {};
  }

  Future<void> init(BuildContext context) async {
    markersProvider = MarkersProvider(deviceProvider.devices, context);
    _initCluster();
    await fetchDevices(init: true);
    await markersProvider.setMarkers(deviceProvider.devices);
    notifyListeners();
  }

  Future<void> moveCamera(LatLng pos, {double zoom = 6}) async {
    await googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: pos, zoom: zoom),
    ));
  }

  Future<void> fetchInitDevice() async {
    if (_init) {
      if (markersProvider.fetchGroupesDevices) {
        await fetchDevices();
      } else {
        await fetchDevice(deviceProvider.selectedDevice.deviceId, isSelected: true);
      }
    }
    _init = true;
  }

  set devices(List<Device> devices) {
    deviceProvider.devices = devices;
    notifyListeners();
  }

  void handleSelectDevice({bool notify = true}) {
    menuIsClicked(false);
    if (notify) {
      enableZoomGesture = true;
    }
    if (markersProvider.fetchGroupesDevices) {
      autoSearchController.text = 'Touts les véhicules';
    } else {
      autoSearchController.text = deviceProvider.selectedDevice.description;
    }
  }

  void onTapEnter(String val) {
    deviceProvider.selectedDevice = deviceProvider.devices.firstWhere(
      (device) {
        return device.description.toLowerCase().contains(
              val.toLowerCase(),
            );
      },
    );
    handleSelectDevice();
    notifyListeners();
    fetchDevice(deviceProvider.selectedDevice.deviceId);
  }

  bool _enableZoomGesture = true;

  bool get enableZoomGesture => _enableZoomGesture;

  set enableZoomGesture(bool enableZoomGesture) {
    _enableZoomGesture = enableZoomGesture;
    notifyListeners();
  }

  void updateSimpleClusterMarkers(Set<Marker> ms) {
    markersProvider.clusterMarkers = ms;
    notifyListeners();
  }

  void updateSimpleMarkersText(Set<Marker> ms) {
    markersProvider.textMakers = ms;
    notifyListeners();
  }

  Future<Marker> Function(Cluster<Place>) markerBuilder(bool isText) =>
      (cluster) async {
        if (!isText) {
          return markersProvider.getClusterMarker(cluster);
        }
        if (isText && !cluster.isMultiple) {
          return await markersProvider
              .getTextMarker(cluster.items.first.device);
        }
        return const Marker(markerId: MarkerId(''), visible: false);
      };

  void _initCluster() {
    markersProvider.initCluster(this);
  }

  late bool loadingRoute = false;

  Future<void> buildRoutes() async {
    if (polylines.isNotEmpty) {
      polylines.clear();
      notifyTheMap();
      return;
    }

    loadingRoute = true;
    notifyTheMap();
    List<LatLng> points = await _getRouteCoordinates();
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('PolylineId'),
        width: 7,
        visible: true,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        points: points,
        color: Colors.blue[600]!,
        jointType: JointType.round,
      ),
    );
    loadingRoute = false;
    notifyTheMap();
  }

  Future<List<LatLng>> _getRouteCoordinates() async {
    Position myLocation = await Geolocator.getCurrentPosition();

    var res = await api.post(url: '/route', body: {
      "origin": "${myLocation.latitude},${myLocation.longitude}",
      "destination":
          "${deviceProvider.selectedDevice.latitude},${deviceProvider.selectedDevice.longitude}"
    });

    if (res.isEmpty) return [];
    var points = List<LatLng>.from(
        json.decode(res).map((e) => LatLng(e[0], e[1])).toList());
    return points;
  }

  bool _fetchOneDevice = false;

  Future<void> fetchDevice(String deviceId, {bool isSelected = false}) async {
    if (_fetchOneDevice) {
      return;
    }
    _fetchOneDevice = true;
    Account? account = shared.getAccount();

    markersProvider.fetchGroupesDevices = false;
    markersProvider.simpleMarkers = {};

    String res = await api.post(
      url: '/device',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': deviceId,
        'is_web': true
      },
    );

    if (markersProvider.fetchGroupesDevices) {
      return;
    }

    if (res.isNotEmpty) {
      //log(res);
      Device device = Device.fromMap(json.decode(res));
      deviceProvider.selectedDevice = device;
      await fetchInfoData();
      markersProvider.onMarker.clear();
      markersProvider.onMarker.add(markersProvider.getSimpleMarker(device));
      markersProvider.fetchGroupesDevices = false;
      notifyListeners();
    }
    await Future.delayed(const Duration(seconds: 1));
    if (isSelected) {
      if (polylines.isNotEmpty) {
        await buildRoutes();
      }
      moveCamera(
          LatLng(deviceProvider.selectedDevice.latitude,
              deviceProvider.selectedDevice.longitude),
          zoom: 14);
    }

    _fetchOneDevice = false;
  }

  bool _fetchAllDevices = false;

  void _fetchDevicesFromSelect() async {
    for (Device device in deviceProvider.devices) {
      Marker marker = markersProvider.getSimpleMarker(device);
      Marker textmarker = await markersProvider.getTextMarker(device);
      markersProvider.simpleMarkers.add(marker);
      markersProvider.textMakers.add(textmarker);
      notifyListeners();
    }
  }

  Future<void> fetchDevices(
      {bool fromSelect = false, bool init = false}) async {
    if (fromSelect) {
      googleMapController?.animateCamera(CameraUpdate.zoomTo(6.5));
      _fetchDevicesFromSelect();
    }

    if (_fetchAllDevices) {
      return;
    }
    _fetchAllDevices = true;
    markersProvider.fetchGroupesDevices = true;
    polylines = {};

    deviceProvider.devices = await deviceProvider.fetchDevices(init: init);
    lastDateFetchDevices = DateTime.now();
    if (deviceProvider.devices.length == 1) {
      deviceProvider.selectedDevice = deviceProvider.devices.first;
    }
    markersProvider.simpleMarkers.clear();
    markersProvider.textMakers.clear();

    if (!markersProvider.fetchGroupesDevices) {
      markersProvider.fetchGroupesDevices = false;
      _fetchAllDevices = false;
      return;
    }

    for (Device device in deviceProvider.devices) {
      Marker marker = markersProvider.getSimpleMarker(device);
      Marker textmarker = await markersProvider.getTextMarker(device);
      markersProvider.simpleMarkers.add(marker);
      markersProvider.textMakers.add(textmarker);
    }
    markersProvider.fetchGroupesDevices = true;
    _fetchAllDevices = false;
    notifyListeners();
  }
}
