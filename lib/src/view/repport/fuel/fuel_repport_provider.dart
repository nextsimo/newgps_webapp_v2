import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/fuel_repport_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';

class FuelRepportProvider with ChangeNotifier {
  List<FuelRepportData> repports = [];
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> fetchRepports(String deviceId, RepportProvider repportProvider,
      {bool fromInside = false}) async {
    if (!fromInside) {
      repports = [];
      day = 0;
    }
    Account? account = shared.getAccount();
    loading = true;
    for (DateTime i = repportProvider.dateFrom;
        i.isBefore(repportProvider.dateTo);
        i = i.add(const Duration(days: 1))) {
      debugPrint(
        {
          'account_id': account?.account.accountId,
          'device_id': deviceId,
          'year': i.year,
          'month': i.month,
          'day': i.day,
          'date_from': 0,
          'date_to': 0,
          'hour_from': repportProvider.dateFrom.hour + 1,
          'minute_from': repportProvider.dateFrom.minute,
          'hour_to': repportProvider.dateTo.hour,
          'minute_to': repportProvider.dateTo.minute,
          'download': false,
        }.toString(),
      );
      String res = await api.post(
        url: '/repport/resume/fuelbydate',
        body: {
          'account_id': account?.account.accountId,
          'device_id': deviceId,
          'year': i.year,
          'month': i.month,
          'day': i.day,
          'date_from': 0,
          'date_to': 0,
          'hour_from': repportProvider.dateFrom.hour + 1,
          'minute_from': repportProvider.dateFrom.minute,
          'hour_to': repportProvider.dateTo.hour,
          'minute_to': repportProvider.dateTo.minute,
          'download': false,
        },
      );

      if (res.isNotEmpty) {
        repports.add(fuelRepportDataFromJson(res).first);
        notifyListeners();
      }
    }

    loading = false;
  }

  int day = 0;

  int selectedIndex = 0;

  bool orderByDate = false;
  void updateDateOrder(_) {
    orderByDate = !orderByDate;
    repports.sort((r1, r2) => r1.date.compareTo(r2.date));
    if (!orderByDate) repports = repports.reversed.toList();
    selectedIndex = 0;
    notifyListeners();
  }

  bool orderByFuelConsom = false;
  void updateFuelConsome(_) {
    orderByFuelConsom = !orderByFuelConsom;
    repports.sort((r1, r2) => r1.carbConsomation.compareTo(r2.carbConsomation));
    if (!orderByFuelConsom) repports = repports.reversed.toList();
    selectedIndex = 1;
    notifyListeners();
  }

  bool orderByFuelConsome100 = false;
  void updateFuelConsome100(_) {
    orderByFuelConsome100 = !orderByFuelConsome100;
    repports.sort(
        (r1, r2) => r1.carbConsomation100.compareTo(r2.carbConsomation100));
    if (!orderByFuelConsome100) repports = repports.reversed.toList();
    selectedIndex = 2;
    notifyListeners();
  }

  bool orderByDistance = false;
  void updateByDistance(_) {
    orderByDistance = !orderByDistance;
    repports.sort((r1, r2) => r1.distance.compareTo(r2.distance));
    if (!orderByDistance) repports = repports.reversed.toList();
    selectedIndex = 3;
    notifyListeners();
  }

  bool oderByDrivingTime = false;
  void updateByDrivingTime(_) {
    oderByDrivingTime = !oderByDrivingTime;
    repports.sort(
        (r1, r2) => r1.drivingTimeBySeconds.compareTo(r2.drivingTimeBySeconds));
    if (!oderByDrivingTime) repports = repports.reversed.toList();
    selectedIndex = 4;
    notifyListeners();
  }
}
