import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';

class CameraProvider with ChangeNotifier {
  // ignore: library_private_types_in_public_api
  late _AutoSearchHandler auto;

  List<Device> devices = [];

  void _init() {
    devices = deviceProvider.devices;
    auto = _AutoSearchHandler(onSelected, handleSelection);
  }

  CameraProvider() {
    _init();
  }

  void handleSelection() {
    if (auto.deviceID == 'all') {
      auto.controller.text = 'Touts les véhicules';
    } else {
      auto.controller.text = auto.selectedDevice.description;
    }
    //notifyListeners();
  }

  void onSelected(String deviceId) {
    if (deviceId == 'all') {
      devices = deviceProvider.devices;
    } else {
      devices = [
        deviceProvider.devices.firstWhere((e) => e.deviceId == deviceId)
      ];
    }
    notifyListeners();
  }
}

class _AutoSearchHandler {
  TextEditingController controller =
      TextEditingController(text: 'Touts les véhicules');

  late void Function(String id) onSelect;
  late void Function() handleSelectDevice;

  _AutoSearchHandler(
      void Function(String id) myFunc, void Function() handleSelectedDevice) {
    onSelect = myFunc;
    handleSelectDevice = handleSelectedDevice;
  }
  String deviceID = 'all';
  late Device selectedDevice;

  void clear() {
    controller.text = '';
  }

  void initController(TextEditingController c) {
    controller = c;
  }

  void onClickAll() {
    deviceID = 'all';
    handleSelectDevice();
    onSelect('all');
  }

  void onTapDevice(Device device) {
    selectedDevice = device;
    deviceID = device.deviceId;
    onSelect(device.deviceId);
  }
}
