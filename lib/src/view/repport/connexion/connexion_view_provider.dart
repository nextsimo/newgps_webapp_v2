import 'package:flutter/material.dart';

import '../../../models/account.dart';
import '../../../services/newgps_service.dart';
import '../../connected_device/connected_device_model.dart';
import '../rapport_provider.dart';

class ConnexionViewProvider with ChangeNotifier {
  late RepportProvider provider;

  List<ConnectedDeviceModel> _devices = [];

  List<ConnectedDeviceModel> get devices => _devices;

  set devices(List<ConnectedDeviceModel> devices) {
    _devices = devices;
    notifyListeners();
  }

  ConnexionViewProvider(RepportProvider p) {
    provider = p;
  }
  bool loading = false;
  int selectedIndex = 3;
  bool up = false;

  String orderBy = 'updated_at';

  Future<void> orderByClick(int? index) async {
    selectedIndex = index ?? 2;
    if (loading) return;
    loading = true;
    up = !up;
    switch (index) {
      case 1:
        orderBy = 'device_brand';
        break;
      case 2:
        orderBy = 'platform';
        break;
      case 3:
        orderBy = 'updated_at';
        break;
      case 4:
        orderBy = 'connected_state';
        break;
      default:
        orderBy = 'updated_at';
    }
    await fetchConnectedDevices();
    loading = false;
  }

  Future<void> fetchConnectedDevices() async {
    Account? account = shared.getAccount();
    debugPrint(provider.dateFrom.toString());
    debugPrint(provider.dateTo.toString());
    String res = await api.post(
      url: '/repport/connected/devices',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': provider.dateFrom.toString(),
        'date_to': provider.dateTo.toString(),
        'order_by': orderBy,
        'up': up ? 'asc' : 'desc',
      },
    );
    devices = connectedDeviceModelFromJson(res);
    debugPrint("{$devices}");
  }
}
