import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/geozne_sttings_alert.dart';
import 'package:newgps/src/models/geozone.dart';
import 'package:newgps/src/services/firebase_messaging_service.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/view/geozone/geozone_dialog/geozone_action_view.dart';
import 'package:newgps/src/view/geozone/geozone_dialog/geozone_dialog_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class GeozoneProvider with ChangeNotifier {
  late List<GeozoneModel> _geozones = [];

  FirebaseMessagingService? firebaseMessagingService;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  List<GeozoneModel> get geozones => _geozones;

  GeozoneSttingsAlert? geozoneSttingsAlert;

  final GeozoneDialogProvider geozoneDialogProvider = GeozoneDialogProvider();

  String _errorText = '';

  String get errorText => _errorText;

  set errorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  set geozones(List<GeozoneModel> geozones) {
    _geozones = geozones;
    notifyListeners();
  }

  GeozoneProvider() {
    init();
  }

  void init() {
    fetchGeozones();
    _fetchAlertSettings();
  }

  Future<void> _fetchAlertSettings() async {
    String res = await api.post(
      url: '/alert/geozone/settings',
      body: {
        'notification_id': NewgpsService.messaging.notificationID,
        'account_id': shared.getAccount()?.account.accountId
      },
    );

    if (res.isNotEmpty) {
      geozoneSttingsAlert = geozoneSttingsAlertFromJson(res);
      notifyListeners();
    }
  }

  Future<void> updateSettings(bool newValue) async {
    await api.post(
      url: '/alert/geozone/update',
      body: {
        'is_active': newValue,
        'notification_id': NewgpsService.messaging.notificationID
      },
    );

    await _fetchAlertSettings();
  }

  bool activeAlert = false;

  void updateActiveAlert(bool val) {
    activeAlert = val;
    notifyListeners();
  }

  Future<void> addGeozone(double radius, LatLng center, String description,
      BuildContext context) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/add/geozone', body: {
      'accountId': account?.account.accountId,
      'cordinates': geozoneDialogProvider.selectionType == 0
          ? json.encode(List<List<double>>.from(geozoneDialogProvider.markers
              .map((e) => [e.position.latitude, e.position.longitude])
              .toList()))
          : json.encode(List<List<double>>.from(geozoneDialogProvider.pointLines
              .map((e) => [e.latitude, e.longitude])
              .toList())),
      'radius': radius,
      'description': description,
      'geozone_type': geozoneDialogProvider.selectionType,
      'innerOuterValue': geozoneDialogProvider.innerOuterValue,
      'zoom': geozoneDialogProvider.currentZoome,
    });

    if (res.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Nom de geozone déja exister'),
        ),
      );
    }

    //debugPrint(res);

    fetchGeozones();

    // nav.back();
  }

  Future<void> updateGeozone(double radius, LatLng center, String description,
      BuildContext context) async {
    Account? account = shared.getAccount();
    String res = await api.post(url: '/update/geozone', body: {
      'accountId': account?.account.accountId,
      'cordinates': geozoneDialogProvider.selectionType == 0
          ? json.encode(List<List<double>>.from(geozoneDialogProvider.markers
              .map((e) => [e.position.latitude, e.position.longitude])
              .toList()))
          : json.encode(List<List<double>>.from(geozoneDialogProvider.pointLines
              .map((e) => [e.latitude, e.longitude])
              .toList())),
      'radius': radius,
      'description': description,
      'geozone_type': geozoneDialogProvider.selectionType,
      'innerOuterValue': geozoneDialogProvider.innerOuterValue,
      'zoom': geozoneDialogProvider.currentZoome,
    });

    if (res.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Nom de geozone déja exister'),
        ),
      );
    }

    //debugPrint(res);

    fetchGeozones();

    // nav.back();
  }

  Future<void> onClickUpdate(GeozoneModel geozone, BuildContext context,
      {bool readOnly = false}) async {
    geozoneDialogProvider.onClickUpdate(geozone);
    bool? saved = await showDialog(
      context: context,
      builder: (_) => Dialog(
          child: GeozoneActionView(
        readonly: readOnly,
        geozoneDialogProvider: geozoneDialogProvider,
      )),
    );

    if (saved!) {
      await updateGeozone(
          double.parse(geozoneDialogProvider.controllerGeozoneMetre.text),
          geozoneDialogProvider.pos,
          geozoneDialogProvider.controllerGeozoneName.text,
          context);
    }

    await fetchGeozones();
    geozoneDialogProvider.clear();
  }

  Future<void> fetchGeozones() async {
    Account? account = shared.getAccount();

    String res = await api.post(
        url: '/geozones', body: {"accountId": account?.account.accountId});

    if (res.isNotEmpty) {
      geozones = geozoneModelFromJson(res);
    }
  }

  void deleteGeozone(BuildContext context, String geozoneId) async {
    bool res = await customDialog(context);
    Account? account = shared.getAccount();

    //log('$res');
    if (res) {
      await api.post(url: '/delete/geozone', body: {
        'accountId': account?.account.accountId,
        'geozoneId': geozoneId,
      });
      fetchGeozones();
    }
  }

  Future<void> showAddDialog(BuildContext context) async {
    bool? saved = await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GeozoneActionView(
          geozoneDialogProvider: geozoneDialogProvider,
        ),
      ),
    );

    if (saved != null && saved) {
      await addGeozone(
          double.parse(geozoneDialogProvider.controllerGeozoneMetre.text),
          geozoneDialogProvider.pos,
          geozoneDialogProvider.controllerGeozoneName.text,
          context);
    }
    geozoneDialogProvider.clear();
  }

  Future<bool> customDialog(BuildContext context) async {
    bool res = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 40,
            ),
            content: const Text(
                'Etes-vous sûr que vous voulez supprimer ce geoszone'),
            actions: [
              MainButton(
                width: 90,
                height: 40,
                onPressed: () {
                  res = true;
                  Navigator.of(context).pop();
                  return;
                },
                label: 'Oui',
              ),
              const SizedBox(
                height: 20,
              ),
              MainButton(
                width: 90,
                height: 40,
                onPressed: () {
                  res = false;
                  Navigator.of(context).pop();
                  return;
                },
                label: 'Annuler',
              ),
            ],
          );
        });

    return res;
  }
}
