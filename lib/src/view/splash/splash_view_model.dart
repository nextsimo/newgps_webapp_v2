import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/navigation/navigation_view.dart';
import 'package:provider/provider.dart';

import '../connected_device/connected_device_provider.dart';

class SplashViewModel with ChangeNotifier {
  Future<void> init(BuildContext context, {bool alert = false}) async {
    checkIfUserIsAuth(context, alert);
  }

  void checkIfUserIsAuth(BuildContext context, bool alert) async {
    await Future.delayed(const Duration(seconds: 3));
    if (shared.getAccount() != null) {
      HistoricProvider historicProvider =
          Provider.of<HistoricProvider>(context, listen: false);
      LastPositionProvider lastPositionProvider =
          Provider.of<LastPositionProvider>(context, listen: false);
      await fetchInitData(
          historicProvider: historicProvider,
          lastPositionProvider: lastPositionProvider,
          context: context);

      final ConnectedDeviceProvider connectedDeviceProvider =
          Provider.of<ConnectedDeviceProvider>(context, listen: false);
      connectedDeviceProvider.init();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => CustomNavigationView(
              alert: alert,
            ),
          ),
          (_) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }
}
