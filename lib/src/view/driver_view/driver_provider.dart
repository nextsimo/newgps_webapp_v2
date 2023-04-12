import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';

class DriverViewProvider with ChangeNotifier {
  late AutoSearchHandler auto;

  List<DataDevice> devices = [];
  List<DataDevice> _fixDevices = [];

  void _init() {
    _fixDevices = List.from(deviceProvider.devices.map((e) {
      return DataDevice(
          description: e.description,
          note: 20,
          color: Colors.green,
          deviceId: e.deviceId);
    }).toList());

    _fixDevices.sort((d1, d2) => d1.note.compareTo(d2.note));

    devices = _fixDevices;
    auto = AutoSearchHandler(onSelected, handleSelection);
  }

  void handleSelection() {
    if (auto.deviceID == 'all') {
      auto.controller.text = 'Touts les véhicules';
    } else {
      auto.controller.text = auto.selectedDevice.description;
    }
    notifyListeners();
  }

  DriverViewProvider() {
    _init();
  }

  void onSelected(String deviceId) {
    if (deviceId == 'all') {
      devices = _fixDevices;
    } else {
      devices = [_fixDevices.firstWhere((e) => e.deviceId == deviceId)];
    }
    notifyListeners();
  }
}

class AutoSearchHandler {
  TextEditingController controller =
      TextEditingController(text: 'Touts les véhicules');

  late void Function(String id) onSelect;
  late void Function() handleSelectDevice;

  AutoSearchHandler(
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

class DataDevice {
  final String description;
  final int note;
  final Color color;
  final String deviceId;

  DataDevice(
      {required this.description,
      required this.note,
      required this.color,
      required this.deviceId});
}
