import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/services/newgps_service.dart';

import 'package:newgps/src/utils/functions.dart';
import '../../alert/alert_navigation.dart';
import '../../camera/camera_view.dart';
import '../../driver_view/driver_view.dart';
import '../../geozone/geozone_view.dart';
import '../../gestion/gestion_view.dart';
import '../../historic/historic_view.dart';
import '../../last_position/last_position_view.dart';
import '../../matricule/matricule_view.dart';
import '../../repport/repport_view.dart';
import '../../user/user_view.dart';
import '../../user_empty_page.dart';

class SavedAcountProvider with ChangeNotifier {
  List<SavedAccount> _savedAcounts = [];

  int _numberOfNotif = 0;

  int get numberOfNotif => _numberOfNotif;

  set numberOfNotif(int numberOfNotif) {
    _numberOfNotif = numberOfNotif;
    notifyListeners();
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> checkNotifcation() async {
    String res = await api.post(
      url: '/notification/historics/count/extra',
      body: await getBody()
        ..addAll({
          'device_id': await getDeviceToken(),
          'notification_id': NewgpsService.messaging.notificationID
        }),
    );

    if (res.isNotEmpty) {
      numberOfNotif = jsonDecode(res);
    }
  }

  late UserDroits userDroits = UserDroits(
    id: 0,
    userId: '',
    accountId: '',
    droits: [
      Droit(read: true, write: true, index: 0),
      Droit(read: true, write: true, index: 1),
      Droit(read: true, write: true, index: 2),
      Droit(read: true, write: true, index: 3),
      Droit(read: true, write: true, index: 4),
      Droit(read: true, write: true, index: 5),
      Droit(read: true, write: true, index: 6),
      Droit(read: true, write: true, index: 7),
      Droit(read: true, write: true, index: 8),
      Droit(read: true, write: true, index: 9),
    ],
  );

  void initUserDroit() {
    userDroits = UserDroits(
      id: 0,
      userId: '',
      accountId: '',
      droits: [
        Droit(read: true, write: true, index: 0),
        Droit(read: true, write: true, index: 1),
        Droit(read: true, write: true, index: 2),
        Droit(read: true, write: true, index: 3),
        Droit(read: true, write: true, index: 4),
        Droit(read: true, write: true, index: 5),
        Droit(read: true, write: true, index: 6),
        Droit(read: true, write: true, index: 7),
        Droit(read: true, write: true, index: 8),
        Droit(read: true, write: true, index: 9),
      ],
    );
  }

  final List<Widget> _accountWidget = [
    const LastPositionView(),
    const HistoricView(),
    const RepportView(),
    const AlertNavigation(),
    const GeozoneView(),
    const UsersView(),
    const MatriculeView(),
    const CameraView(),
    const GestionView(),
    const DriverView(),
  ];

  List<Widget> buildPages() {
    Account? account = shared.getAccount();
    if (account!.account.userID == null || account.account.userID!.isEmpty) {
      return _accountWidget;
    }

    List<Widget> userPages = [];

    userPages = [
      if (userDroits.droits[1].read) const LastPositionView(),
      if (userDroits.droits[2].read) const HistoricView(),
      if (userDroits.droits[3].read) const RepportView(),
      if (userDroits.droits[4].read) const AlertNavigation(),
      if (userDroits.droits[5].read) const GeozoneView(),
      if (userDroits.droits[7].read) const MatriculeView(),
      if (userDroits.droits[8].read) const CameraView(),
      if (userDroits.droits[9].read) const GestionView(),
      if (userDroits.droits[10].read) const DriverView(),
    ];

    if (userPages.isEmpty) return [const UserEmptyPage()];
    return userPages;
  }

  Future<void> fetchUserDroits() async {
    Account? account = shared.getAccount();
    if (account!.account.userID == null || account.account.userID!.isEmpty) {
      return;
    }
    String res = await api.post(url: '/user/droits/show', body: {
      'account_id': account.account.accountId,
      'user_id': account.account.userID,
    });
    userDroits = userDroitsFromJson(res);
  }

  List<SavedAccount> get savedAcounts => _savedAcounts;
  final String acountsKey = 'saved_acounts';
  set savedAcounts(List<SavedAccount> savedAcounts) {
    _savedAcounts = savedAcounts;
    notifyListeners();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  SavedAcountProvider() {
    init();
  }

  Future<void> init() async {
    getSavedAccount();
  }

  bool accountExist(String? user, String? key) {
    bool res = shared.getAcountsList(acountsKey).contains(user);
    return res;
  }

  void savedAcount(String? user, String password, [String? underUser = '']) {
    if (underUser != null && underUser.isNotEmpty) {
      deleteUserAccount(underUser, user);
    } else {
      deleteAcount(user);
    }
    _savedAcounts.add(
        SavedAccount(user: user, password: password, underUser: underUser));
    saveAcountsList(_savedAcounts);
  }

  void deleteUserAccount(String underUser, String? user) {
    savedAcounts
        .removeWhere((ac) => ac.underUser == underUser && ac.user == user);
    saveAcountsList(savedAcounts);
    notifyListeners();
  }

  void getSavedAccount() {
    List<String> strings = shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      savedAcounts = List<SavedAccount>.from(strings
          .map<SavedAccount>(
            (e) => SavedAccount(
              user: e.split(',').first,
              password: e.split(',').elementAt(1),
              underUser: e.split(',').last == 'null' ? '' : e.split(',').last,
            ),
          )
          .toList());
    }
  }

  List<SavedAccount> fetchSavedAccount() {
    List<String> strings = shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      return List<SavedAccount>.from(strings
          .map<SavedAccount>(
            (e) => SavedAccount(
              user: e.split(',').first,
              password: e.split(',').elementAt(1),
              underUser: e.split(',').last == 'null' ? '' : e.split(',').last,
            ),
          )
          .toList());
    }
    return [];
  }

  SavedAccount? getAccount(String? accontID) {
    List<String> strings = shared.getAcountsList(acountsKey);
    if (strings.isNotEmpty) {
      List<SavedAccount> _acconts =
          savedAcounts = List<SavedAccount>.from(strings
              .map<SavedAccount>(
                (e) => SavedAccount(
                  user: e.split(',').first,
                  password: e.split(',').elementAt(1),
              underUser: e.split(',').last == 'null' ? '' : e.split(',').last,

                ),
              )
              .toList());
      return _acconts.firstWhere((ac) => ac.user == accontID);
    }
    return null;
  }

  void deleteAcount(String? user, {bool disableSetting = false}) {
    savedAcounts.removeWhere((ac) => ac.user == user);
    saveAcountsList(savedAcounts);
    if (disableSetting) disapleAllNotification(user);
    notifyListeners();
  }

  void disapleAllNotification(String? account) {
    NewgpsService.messaging.disableAllSettings(account);
  }

  void saveAcountsList(List<SavedAccount> acounts) {
    _savedAcounts = acounts;
    List<String> newListAcounts = List<String>.from(
        acounts.map((e) => '${e.user},${e.password},${e.underUser}').toList());
    shared.setStringList(acountsKey, newListAcounts);
  }
}

class SavedAccount {
  final String? user;
  final String? underUser;
  final String password;

  SavedAccount(
      {required this.user, required this.password, this.underUser = ''});
}
