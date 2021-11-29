import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
  late List<Device> _devices = [];
  late Set<Polyline> polylines = {};
  late bool fetchAll = true;
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
    log("$state");
    await markersProvider.onClickGroupment(state, devices);
    notifyListeners();
  }

  Future<void> onClickMatricule(bool state) async {
    matriculeClicked = state;
    log("$state");
    await markersProvider.onClickMatricule(state, devices);
    notifyListeners();
  }

  GoogleMapController? googleMapController;

  List<Device> get devices => _devices;

  TextEditingController autoSearchController =
      TextEditingController(text: 'Touts les véhicules');
  void fresh() {
    _devices = [];
    polylines = {};
    fetchAll = true;
    lastDateFetchDevices = DateTime.now();
    notifyMap = false;
    googleMapController?.dispose();
    markersProvider.clusterItems = [];
    markersProvider.clusterItemsText = [];
    markersProvider.clusterMarkers = {};
    markersProvider.onMarker = {};
    //markersProvider.textMarkerManager.updateMap();
    //markersProvider.simpleMarkerManager.updateMap();
    markersProvider.fetchGroupesDevices = true;
    markersProvider.showMatricule = false;
    markersProvider.showCluster = false;
    markersProvider.devices = [];
    markersProvider.textMakers = {};
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    markersProvider = MarkersProvider(devices, context);
    _initCluster();
    await fetchDevices();
    await markersProvider.setMarkers(devices);
    notifyListeners();
  }

  Future<void> moveCamera(LatLng pos, {double zoom = 6}) async {
    await googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: pos, zoom: zoom),
    ));
  }

  Future<void> fetchInitDevice() async {
    if (_init) {
      if (fetchAll) {
        await fetchDevices();
      } else {
        await fetchDevice(deviceProvider.selectedDevice.deviceId);
      }
    }
    _init = true;
  }

  set devices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }

  void handleSelectDevice({bool notify = true}) {
    menuIsClicked(false);
    if (notify) {
      enableZoomGesture = true;
    }
    if (fetchAll) {
      autoSearchController.text = 'Touts les véhicules';
    } else {
      autoSearchController.text = deviceProvider.selectedDevice.description;
    }
  }

  void onTapEnter(String val) {
    deviceProvider.selectedDevice = devices.firstWhere(
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

  Future<void> fetchDevice(String deviceId, {bool isSelected = false}) async {
    Account? account = shared.getAccount();

    fetchAll = false;
    markersProvider.simpleMarkers = {};
    polylines = {};
    String res = await api.post(
      url: '/device',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': deviceId,
        'is_web': true
      },
    );

    if (res.isNotEmpty) {
      log(res);
      Device device = Device.fromMap(json.decode(res));
      deviceProvider.selectedDevice = device;
      await fetchInfoData();
      markersProvider.onMarker.clear();
      markersProvider.onMarker.add(markersProvider.getSimpleMarker(device));
      markersProvider.fetchGroupesDevices = false;
      notifyListeners();
    }
    Marker myPositionMarker = await deviceProvider.getPositionMarker();
    markersProvider.onMarker.add(myPositionMarker);
    await Future.delayed(const Duration(seconds: 1));
    if (isSelected) {
      moveCamera(LatLng(deviceProvider.selectedDevice.latitude,
          deviceProvider.selectedDevice.longitude));
    }
  }

  Future<void> fetchDevices() async {
    fetchAll = true;
    polylines = {};

    _devices = await deviceProvider.fetchDevices();
    lastDateFetchDevices = DateTime.now();
    if (_devices.length == 1) deviceProvider.selectedDevice = _devices.first;
    markersProvider.simpleMarkers.clear();
    markersProvider.textMakers.clear();
    for (Device device in _devices) {
      Marker marker = markersProvider.getSimpleMarker(device);
      Marker textmarker = await markersProvider.getTextMarker(device);
      markersProvider.simpleMarkers.add(marker);
      markersProvider.textMakers.add(textmarker);
    }
    Marker myPositionMarker = await deviceProvider.getPositionMarker();
    markersProvider.simpleMarkers.add(myPositionMarker);
    markersProvider.fetchGroupesDevices = true;
    notifyListeners();
  }
}
