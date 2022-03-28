import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class NavigationProvider {
  PageController pageController = PageController();

  String initAlertRoute = 'alert';

  void navigateToAlertHistoric({required String accountId}) async {
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);

    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(DeviceSize.c, listen: false);
    SavedAccount? accounts = acountProvider
        .fetchSavedAccount()
        .firstWhere((ac) => ac.user == accountId);
    shared.saveAccount(Account(
      account: AccountClass(
        password: accounts.password,
          accountId: accounts.user,
          userID: accounts.underUser,
          description: ''),
      token: accounts.password,
    ));
    fetchInitData(
        lastPositionProvider: lastPositionProvider, context: DeviceSize.c);
    pageController.jumpToPage(3);
    initAlertRoute = '/historics';
  }
}
