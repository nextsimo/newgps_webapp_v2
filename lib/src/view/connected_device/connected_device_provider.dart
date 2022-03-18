import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';

import 'connected_device_model.dart';

class ConnectedDeviceProvider with ChangeNotifier {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // init
  Future<void> init() async {
    await _createNewConnectedDevice();
    _initFetches();
  }

  Future<void> _initFetches() async {
    await _setConnectedToTrue();
    _fetchCountedConnectedDevices();
    _fetchConnectedDevices();
    Timer.periodic(const Duration(seconds: 15), (_) async {
      await _setConnectedToTrue();
      _fetchCountedConnectedDevices();
      _fetchConnectedDevices();
    });
  }

  // counted connected device
  int _countedConnectedDevices = 0;
  int get countedConnectedDevices => _countedConnectedDevices;
  set countedConnectedDevices(int countedConnectedDevices) {
    _countedConnectedDevices = countedConnectedDevices;
    notifyListeners();
  }

  bool _loading1 = false;

  Future<void> _fetchCountedConnectedDevices() async {
    if (_loading1) return;
    _loading1 = true;
    Account? account = shared.getAccount();
    String res = await api.post(url: '/connected/devices/count', body: {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID,
    });
    countedConnectedDevices = json.decode(res);
    _loading1 = false;
  }

  // end counted connected device

  // fetched devices
  List<ConnectedDeviceModel> _conctedDevices = [];

  List<ConnectedDeviceModel> get conctedDevices => _conctedDevices;

  set conctedDevices(List<ConnectedDeviceModel> conctedDevices) {
    _conctedDevices = conctedDevices;
    notifyListeners();
  }

  Future<void> _setConnectedToTrue() async {
    Account? account = shared.getAccount();
    Map<String, String?> deviceInfo = await _getDeviceInfo();
    await api.post(url: '/connected/set', body: {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID,
      'device_brand': deviceInfo['device_brand'],
      'platform': deviceInfo['platform'],
      'device_uid': deviceInfo['device_uid'],
    });
  }

  bool _loading2 = false;

  Future<void> _fetchConnectedDevices() async {
    if (_loading2) return;
    _loading2 = true;
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/connected/devices',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
      },
    );
    conctedDevices = connectedDeviceModelFromJson(res);
    _loading2 = false;
  }
  // end fetched device

  // create new device and set connected to true

  Future<void> _createNewConnectedDevice() async {
    Account? account = shared.getAccount();
    Map<String, String?> deviceInfo = await _getDeviceInfo();
    await api.post(url: '/connected/devices/create', body: {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID,
      'device_brand': deviceInfo['device_brand'],
      'platform': deviceInfo['platform'],
      'device_uid': deviceInfo['device_uid'],
      'os': deviceInfo['os'],
      'is_connected': true,
    });
  }

  Future<void> createNewConnectedDeviceHistoric(bool state) async {
    Account? account = shared.getAccount();
    Map<String, String?> deviceInfo = await _getDeviceInfo();
    await api.post(url: '/connected/devices/create2', body: {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID,
      'device_brand': deviceInfo['device_brand'],
      'platform': deviceInfo['platform'],
      'device_uid': deviceInfo['device_uid'],
      'os': deviceInfo['os'],
      'is_connected': true,
      'connected_state': state,
    });
  }

  Future<Map<String, String?>> _getDeviceInfo() async {
    WebBrowserInfo info = await _deviceInfo.webBrowserInfo;
    return {
      'device_brand': info.platform,
      'platform': 'web',
      'device_uid': '${info.appName}-${info.platform}-${info.productSub}',
      'os': info.browserName.name,
    };
  }
  // end create new device and set connected to true

  // update device status
  Future<void> updateConnectedDevice(bool newState) async {
    Account? account = shared.getAccount();
    Map<String, String?> deviceInfo = await _getDeviceInfo();
    await api.post(url: '/connected/devices/update', body: {
      'account_id': account?.account.accountId,
      'user_id': account?.account.userID,
      'device_brand': deviceInfo['device_brand'],
      'platform': deviceInfo['platform'],
      'device_uid': deviceInfo['device_uid'],
      'is_connected': newState
    });
  }
  // end update device status

}
