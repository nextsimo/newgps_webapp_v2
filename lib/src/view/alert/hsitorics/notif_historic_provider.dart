import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/notif_historic_model.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/view/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

import 'map_view/map_view_alert.dart';
import 'notif_historic_details.dart';

class NotifHistoricPorvider with ChangeNotifier {
  List<NotifHistoric> _histos = [];

  List<NotifHistoric> get histos => _histos;

  List<String> selectedDevices = [];

  String deviceID = 'all';

  late Device selectedDevice;

  set histos(List<NotifHistoric> histos) {
    _histos = histos;
    notifyListeners();
  }

  late String _type;

  NotifHistoricPorvider({String type = ''}) {
    _type = type;
    if (type.isEmpty) {
      fetchHisto();
    } else {
      _fetchDetailsRepport(type: type);
    }
  }

  void call(BuildContext context, String deviceID) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    Device device = deviceProvider.devices
        .firstWhere((element) => element.deviceId == deviceID);
    locator<DriverPhoneProvider>().checkPhoneDriver(
        context: context,
        device: device,
        sDevice: device,
        callNewData: () async {
          await deviceProvider.fetchDevices();
        });
  }

  void _locatedAlert({required BuildContext context, required Device device}) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
                child: MapViewALert(
              device: device,
            )));
  }

  Future<void> findAlertPosition(
      {required BuildContext context,
      required int timestamp,
      required String deviceId}) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/alert/position', body: {
      'account_id': account?.account.accountId,
      'device_id': deviceId,
      'timestamp': timestamp,
      'is_web' : true,
    });

    if (res.isNotEmpty) {
      Device device = Device.fromMap(json.decode(res));
      _locatedAlert(context: context, device: device);
    }
  }

  TextEditingController autoSearchController =
      TextEditingController(text: 'Touts les véhicules');

  void handleSelectDevice() {
    if (deviceID == 'all') {
      autoSearchController.text = 'Touts les véhicules';
    } else {
      autoSearchController.text = selectedDevice.description;
    }
  }

  void fetchDeviceFromSearchWidget() {
    if (deviceID == 'all') {
      _fetchDetailsRepport(type: _type);
    } else {
      _fetchDetailsRepport(type: _type, deviceId: deviceID);
    }
  }

  void initDevices(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of(context, listen: false);
    selectedDevices = List<String>.from(
        deviceProvider.devices.map((e) => e.deviceId).toList());
  }

  void notif() {
    notifyListeners();
  }

  String getLabel(String type) {
    switch (type) {
      case 'fuel':
        return 'carburant';
      case 'battery':
        return 'batterie';
      case 'speed':
        return 'vitesse';
      case 'geozone':
        return 'geozone';
      default:
        return '';
    }
  }

  void navigateToDetaisl(BuildContext context, {required NotifHistoric model}) {
    _saveLastReadToLocal(
        model.type, DateTime.now().toString());
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(context, listen: false);

    acountProvider.checkNotifcation();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => NotifHistorisDetails(type: model.type)));
  }

  Future<void> _fetchDetailsRepport({
    String type = '',
    String deviceId = 'all',
  }) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/notification/historics/details',
      body: {
        'type': type,
        'device_id': deviceId,
        'account_id': account?.account.accountId,
      },
    );
    if (res.isNotEmpty) {
      histos = notifHistoricFromJson(res);
    }
  }

  void _saveLastReadToLocal(String type, String date) {
    switch (type) {
      case 'fuel':
        shared.sharedPreferences.setString(fuelLocalDataKey, date);
        break;
      case 'battery':
        shared.sharedPreferences.setString(batteryLocalDataKey, date);
        break;
      case 'speed':
        shared.sharedPreferences.setString(speedLocalDataKey, date);
        break;
      case 'geozone':
        shared.sharedPreferences.setString(geozoneLocalDataKey, date);
        break;
    }
  }

  Future<void> fetchHisto() async {
    String res = await api.post(
      url: '/notification/historics',
      body: getBody(),
    );
    if (res.isNotEmpty) {
      histos = notifHistoricFromJson(res);
    }
  }
}
