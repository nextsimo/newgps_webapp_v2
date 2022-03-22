import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/info_model.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class DeviceProvider with ChangeNotifier {
  late List<Device> _devices = [];

  List<Device> get devices => _devices;

  set devices(List<Device> devices) {
    _devices = devices;
    notifyListeners();
  }
  String initAlertRoute = '/';

  InfoModel? _infoModel;

  InfoModel? get infoModel => _infoModel;

  set infoModel(InfoModel? infoModel) {
    _infoModel = infoModel;
    notifyListeners();
  }

  late MapType mapType = MapType.normal;

  late Device selectedDevice;

  int selectedTabIndex = 0;

  Future<void> startStopDevice(
      String command, BuildContext context, Device device) async {
    Account? account = shared.getAccount();
    SavedAcountProvider savedAcountProvider =
        Provider.of<SavedAcountProvider>(context, listen: false);

    SavedAccount? savedAccount =
        savedAcountProvider.getAccount(account!.account.accountId);
    String res = await api.post(
      url: '/startstop/device',
      body: {
        'command': command,
        'account_id': account.account.accountId,
        'password': savedAccount!.key,
        'device_id': device.deviceId
      },
    );

    if (res.isNotEmpty) {
      Navigator.of(context).pop();
      bool isStart = command == 'IgnitionEnable';
      String message = isStart ? 'Le démarrage' : "L'arrêt";

      if (json.decode(res).containsKey('Success')) {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 45),
                    const SizedBox(height: 10),
                    const Text('Terminé',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text('$message du véhicule a réussi'),
                    const SizedBox(height: 10),
                    MainButton(
                      width: 170,
                      onPressed: () => Navigator.of(context).pop(),
                      label: 'Fermer',
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(Icons.warning, color: Colors.red, size: 45),
                    const SizedBox(height: 10),
                    const Text('Terminé',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text('$message du véhicule a échouer'),
                    const SizedBox(height: 10),
                    MainButton(
                      width: 170,
                      onPressed: () => Navigator.of(context).pop(),
                      label: 'Fermer',
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      }
    }
  }

  late TextEditingController autoSearchController;

  void handleSelectDevice() {
    autoSearchController.text = selectedDevice.description;
  }

  late BitmapDescriptor markerIcon;

  Future<void> fetchDevice() async {
    Account? account = shared.getAccount();
    String res = await api.post(
      url: '/device',
      body: {
        'accountId': account?.account.accountId,
        'deviceId': selectedDevice.deviceId,
        'is_web': false
      },
    );

    if (res.isNotEmpty) {
      Device device = Device.fromMap(json.decode(res));
      deviceProvider.selectedDevice = device;
    }
  }
/* 
  Future<Marker> getPositionMarker() async {
    var myPos = await GeolocatorPlatform.instance.getCurrentPosition();

    return Marker(
      markerId: const MarkerId('mylocation'),
      icon: markerIcon,
      zIndex: -1,
      position: LatLng(myPos.latitude, myPos.longitude),
    );
  }
 */
  Future<void> init(BuildContext context) async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(35, 35)),
        'assets/icons/position.png');

/*     var request = await http
        .get(Uri.parse('https://api.newgps.ma/api/icons/position.png'));
    var bytes = request.bodyBytes;
    markerIcon = BitmapDescriptor.fromBytes(bytes); */
    devices = await fetchDevices();
    selectedDevice = devices.first;
    autoSearchController =
        TextEditingController(text: selectedDevice.description);
    //notifyListeners();
  }

  Future<List<Device>> fetchDevices({bool init = false}) async {
    Account? account = shared.getAccount();

    Map<String, dynamic> body = {
      'accountId': account?.account.accountId,
      'user_id': account?.account.userID,
      'is_web': true,
    };

    if (init) {
      body.addAll({'init': true});
    }

    String res = await api.post(
      url: '/devices',
      body: body,
    );
    if (res.isNotEmpty) {
      devices = deviceFromMap(res);
      devices.sort((d1, d2) => d2.speedKph.compareTo(d1.speedKph));
      return devices;
    }
    return [];
  }

  SortedColumn sortedColumn = SortedColumn();

  void sortDevices(int index) {
    if (index != sortedColumn.index) {
      sortedColumn.isAsc = true;
    }
    devices.sort((Device d1, Device d2) {
      if (sortedColumn.isAsc) {
        switch (index) {
          case 0:
            return d1.description.compareTo(d2.description);
          case 1:
            return d2.odometerKm.compareTo(d1.odometerKm);
          case 2:
            return d2.speedKph.compareTo(d1.speedKph);
          case 3:
            //return d2.'maxSpeed'!.compareTo(d1.maxSpeed ?? 0);
            return 1;
          case 4:
            return d2.distanceKm.compareTo(d1.distanceKm);
          case 10:
            return d2.dateTime.compareTo(d1.dateTime);
          default:
            return 0;
        }
      } else {
        switch (index) {
          case 0:
            return d2.description.compareTo(d1.description);
          case 1:
            return d1.odometerKm.compareTo(d2.odometerKm);
          case 2:
            return d1.speedKph.compareTo(d2.speedKph);
          case 3:
            //return d1.maxSpeed!.compareTo(d2.maxSpeed ?? 0);
            return 1;
          case 4:
            return d1.distanceKm.compareTo(d2.distanceKm);
          case 10:
            return d1.dateTime.compareTo(d2.dateTime);
          default:
            return 0;
        }
      }
    });
    sortedColumn.isAsc = !sortedColumn.isAsc;
    sortedColumn.index = index;
    notifyListeners();
  }
}

class SortedColumn {
  int index = 2;
  bool isAsc = false;

  SortedColumn({this.index = 2, this.isAsc = false});
}
