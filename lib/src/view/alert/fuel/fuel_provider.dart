import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/fuel_notif_historic.dart';
import 'package:newgps/src/models/fuel_settings_model.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';

class FuelProvider with ChangeNotifier {
  FirebaseMessagingService? messagingService;
  FuelNotifSetting? fuelNotifSetting;
  bool active = false;

  List<FuelNotifHistoric> historics = [
    FuelNotifHistoric(
        id: 12,
        notificationId: 122,
        deviceId: '212',
        deviceName: 'Device name',
        address: 'Casablanca maroc test test',
        latitude: 212,
        fuelValue1: 70.0,
        fuelValue2: 20,
        longitude: 12,
        accountId: 'accountId',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: "12/11/2020"),
    FuelNotifHistoric(
        id: 12,
        notificationId: 122,
        deviceId: '212',
        deviceName: 'Device name',
        address: 'Casablanca maroc test test',
        latitude: 212,
        fuelValue1: 70.0,
        fuelValue2: 20,
        longitude: 12,
        accountId: 'accountId',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: "12/11/2020"),
    FuelNotifHistoric(
        id: 12,
        notificationId: 122,
        deviceId: '212',
        deviceName: 'Device name',
        address: 'Casablanca maroc test test',
        latitude: 212,
        fuelValue1: 70.0,
        fuelValue2: 20,
        longitude: 12,
        accountId: 'accountId',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: "12/11/2020"),
    FuelNotifHistoric(
        id: 12,
        notificationId: 122,
        deviceId: '212',
        deviceName: 'Device name',
        address: 'Casablanca maroc test test',
        latitude: 212,
        fuelValue1: 70.0,
        fuelValue2: 20,
        longitude: 12,
        accountId: 'accountId',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        date: "12/11/2020"),
  ];

  FuelProvider({FirebaseMessagingService? m}) {
    messagingService = m;
    if (m != null) {
      fetchAlert();
    }
  }

  Future<void> onSwitchTaped(bool val) async {
    int notifiId = messagingService!.notificationID;
    await api.post(
      url: '/fuelnotif/update',
      body: {
        'notification_id': notifiId,
        'is_active': val,
      },
    );

    active = val;
    notifyListeners();
  }

  void fetchAlert() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/fuelnotif/settings',
      body: {
        'account_id': account?.account.accountId,
        'notification_id': messagingService!.notificationID,
      },
    );

    if (res.isNotEmpty) {
      fuelNotifSetting = fuelNotifSettingFromJson(res);
      active = fuelNotifSetting!.isActive;
      //await fetchHisto();
      notifyListeners();
    }
  }

  Future<void> fetchHisto() async {
    String res = await api.post(
      url: '/fuelnotif/historics',
      body: {'notification_id': messagingService?.notificationID},
    );
    if (res.isNotEmpty) historics = fuelNotifHistoricFromJson(res);
  }
}
