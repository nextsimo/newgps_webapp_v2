import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/repport_resume_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/repport_type_model.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class RepportProvider with ChangeNotifier {
  late List<Device> devices;
  final List<RepportTypeModel> repportsType = const [
    RepportTypeModel(
      index: 0,
      title: 'Rapport résumer',
    ),
    RepportTypeModel(
      index: 1,
      title: 'Rapport détaillés',
    ),
    RepportTypeModel(
      index: 2,
      title: 'Consomation du carburant',
    ),
    RepportTypeModel(
      index: 3,
      title: 'Rapport arrêt / redémarrage',
    ),
    RepportTypeModel(
      index: 4,
      title: 'Rapport distance',
    ),
    RepportTypeModel(
      index: 5,
      title: 'Rapport connexion',
    ),
  ];

  bool _isFetching = true;

  bool get isFetching => _isFetching;

  set isFetching(bool isFetching) {
    _isFetching = isFetching;
    notifyListeners();
  }

  Future<void> downloadDocument(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MainButton(
                onPressed: downloadXcl,
                label: 'XSL',
              ),
              const SizedBox(height: 10),
              MainButton(
                onPressed: downloadPdf,
                label: 'PDF',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ontapEnterRepportDevice(String val) {
    deviceProvider.selectedDevice = devices.firstWhere((device) {
      return device.description.toLowerCase().contains(val.toLowerCase());
    });
    selectedDevice = deviceProvider.selectedDevice;
    selectAllDevices = false;
    if (selectedRepport.index == repportsType.first.index) {
      selectedRepport = repportsType.elementAt(1);
    }
    handleSelectDevice();
  }

  void ontapEnterRepportType(String val) {
    selectedRepport = repportsType.firstWhere((r) {
      return r.title.toLowerCase().contains(val.toLowerCase());
    });

    if (selectedRepport.index == 0 && !selectAllDevices) {
      selectAllDevices = true;
      handleSelectDevice();
    } else if (selectedRepport.index != 0 && selectAllDevices) {
      selectedDevice = devices.first;
      selectAllDevices = false;
      handleSelectDevice();
    }
  }

  Future<void> downloadXcl() async {
    switch (selectedRepport.index) {
      case 0:
        await downloadResumeRepport();
        break;
      case 1:
        await downlaodDetails('xlsx');
        break;
      case 2:
        await downloadFuelRepport('xlsx');
        break;
      case 3:
        await downlaodTrips('xlsx');
        break;
      case 4:
        if (autoSearchTextController.text == 'Touts les véhicules') {
          await _downloadAllDeistanceDevices('xlsx');
        } else {
          await _downloadOneDeviceDistanceRepport('xlsx');
        }
        break;
      case 5:
        await downlaodConnexion('xlsx');
        break;
      default:
    }
  }

  Future<void> downloadPdf() async {
    switch (selectedRepport.index) {
      case 0:
        await downloadResumeRepport(format: 'pdf');
        break;
      case 1:
        await downlaodDetails('pdf');
        break;
      case 2:
        await downloadFuelRepport('pdf');
        break;
      case 3:
        await downlaodTrips('pdf');
        break;
      case 4:
        if (autoSearchTextController.text == 'Touts les véhicules') {
          await _downloadAllDeistanceDevices('pdf');
        } else {
          await _downloadOneDeviceDistanceRepport('pdf');
        }
        break;
      case 5:
        await downlaodConnexion('pdf');
        break;
      default:
    }
  }

    Future<void> _downloadOneDeviceDistanceRepport(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/distance/device',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'order_by': 'updated_at',
        'or': 'desc',
        'download': true,
        'format': format,
        'device_id': selectedDevice.deviceId,
      },
    );
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute("download",
          "distance_repport_device_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  Future<void> _downloadAllDeistanceDevices(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/distance/all',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'order_by': 'updated_at',
        'or': 'desc',
        'download': true,
        'format': format,
      },
    );

    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute("download",
          "distance_repport_all_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  Future<void> downlaodConnexion(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/connected/devices',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': dateFrom.toString(),
        'date_to': dateTo.toString(),
        'order_by': 'updated_at',
        'up': 'desc',
        'download': true,
        'format': format,
      },
    );

    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute(
          "download", "connexion_rapport_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  DateTime _selectedDateMonth = DateTime.now();

  DateTime get selectedDateMonth => _selectedDateMonth;

  set selectedDateMonth(DateTime selectedDateMonth) {
    _selectedDateMonth = selectedDateMonth;
    notifyListeners();
  }

  Future<void> downlaodDetails(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/repport/details', body: {
      'account_id': account?.account.accountId,
      'device_id': selectedDevice.deviceId,
      'date_from': dateFrom.millisecondsSinceEpoch / 1000,
      'date_to': dateTo.millisecondsSinceEpoch / 1000,
      'index': 0,
      'up': true,
      'download': 1,
      'format': format,
    });
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute(
          "download", "rapport_detailler_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  Future<void> downlaodTrips(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/trips',
      body: {
        'account_id': account?.account.accountId,
        'device_id': selectedDevice.deviceId,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'download': true,
        'format': format
      },
    );
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute(
          "download", "voyage_rapport_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  Future<void> downloadFuelRepport(String format) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/resume/fuelbydate',
      body: {
        'account_id': account?.account.accountId,
        'device_id': selectedDevice.deviceId,
        'year': 0,
        'month': 0,
        'day': 0,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'hour_from': dateFrom.hour,
        'minute_from': dateFrom.minute,
        'hour_to': dateTo.hour,
        'minute_to': dateTo.minute,
        'download': true,
        'format': format
      },
    );

    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$res")
      ..setAttribute(
          "download", "carburant_rapport_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  Future<void> downloadResumeRepport({String format = 'xlsx'}) async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/repport/resume/0',
      body: {
        'account_id': account?.account.accountId,
        'user_id': account?.account.userID,
        'date_from': dateFrom.millisecondsSinceEpoch / 1000,
        'date_to': dateTo.millisecondsSinceEpoch / 1000,
        'download': true,
        'format': format
      },
    );

    String content = res;

    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute(
          "download", "rapport_resumer_${formatSimpleDate(dateFrom)}.$format")
      ..click()
      ..remove();
  }

  late RepportTypeModel _selectedRepport;

  RepportTypeModel get selectedRepport => _selectedRepport;

  set selectedRepport(RepportTypeModel selectedRepport) {
    _selectedRepport = selectedRepport;
    notifyListeners();
  }

  late DateTime dateFrom;
  late DateTime dateTo = DateTime.now();

  void _initDate() {
    dateFrom = DateTime(dateTo.year, dateTo.month, dateTo.day, 0, 0, 0, 1);
    dateTo =  DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59);
    selectedTimeFrom = dateFrom;
    selectedTimeTo = dateTo;
  }

  late Device _selectedDevice;

  Device get selectedDevice => _selectedDevice;

  set selectedDevice(Device selectedDevice) {
    _selectedDevice = selectedDevice;
    notifyListeners();
  }

  bool selectAllDevices = true;

  RepportProvider(List<Device> ds) {
    devices = ds;
    _initDate();
    selectedRepport = repportsType.first;
  }

  late TextEditingController repportTextController;
  late TextEditingController autoSearchTextController;

  void handleRepportType() {
    repportTextController.text = selectedRepport.title;
/*     if (selectAllDevices) {
      fetchRepports(deviceID: 'all', index: 0);
    } */
  }

  void handleSelectDevice() {
    if (selectAllDevices) {
      autoSearchTextController.text = 'Touts les véhicules';
    } else {
      autoSearchTextController.text = selectedDevice.description;
    }
    notifyListeners();
  }

  bool _notifyDate = false;

  bool get notifyDate => _notifyDate;

  set notifyDate(bool notifyDate) {
    _notifyDate = !notifyDate;
    notifyListeners();
  }

  late DateTime selectedTimeFrom;
  late DateTime selectedTimeTo;

  Future<void> updateDateFrom(context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: dateFrom,
      firstDate: DateTime(200),
      lastDate: dateTo,
    );
    if (newDate != null) {
      dateFrom = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        dateFrom.hour,
        dateFrom.minute,
        dateFrom.second,
      );
      notifyDate = _notifyDate;
      hanleFetchRepports();
    }
  }

  Future<void> updateDateTo(context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: dateTo,
      firstDate: dateFrom,
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      dateTo = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        dateTo.hour,
        dateTo.minute,
        dateTo.second,
      );
      notifyDate = _notifyDate;
      hanleFetchRepports();
    }
  }

  void hanleFetchRepports() {
    if (selectedRepport.index == 0) {
      //fetchRepports(deviceID: selectedDevice.deviceId);
    } else {
      notifyListeners();
    }
  }

  void restaureTime(BuildContext context) {
    DateTime now = DateTime.now();
    dateFrom = DateTime(
      dateFrom.year,
      dateFrom.month,
      dateFrom.day,
      0,
      0,
      1,
    );
    dateTo = DateTime(
      dateTo.year,
      dateTo.month,
      dateTo.day,
      now.hour,
      now.minute,
      now.second,
    );
    notifyDate = _notifyDate;
    hanleFetchRepports();
    Navigator.of(context).pop();
  }

  void updateTime(BuildContext context) {
    dateFrom = DateTime(
      dateFrom.year,
      dateFrom.month,
      dateFrom.day,
      selectedTimeFrom.hour,
      selectedTimeFrom.minute,
      selectedTimeFrom.second,
    );
    dateTo = DateTime(
      dateTo.year,
      dateTo.month,
      dateTo.day,
      selectedTimeTo.hour,
      selectedTimeTo.minute,
      selectedTimeTo.second,
    );
    notifyDate = _notifyDate;
    Navigator.of(context).pop();
    hanleFetchRepports();
  }

  Future<void> onSave(RepportResumeModel repportResumeModel) async {
    Account? account = shared.getAccount();

    //debugPrint(jsonEncode(repportResumeModel.toJson()));
    await api.post(
      url: '/repport/resume/update',
      body: {
        'account_id': account?.account.accountId,
        'data': json.encode(repportResumeModel.toJson())
      },
    );
  }
}
