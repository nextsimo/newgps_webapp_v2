import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class SplashViewModel with ChangeNotifier {
  Future<void> init(BuildContext context) async {
    checkIfUserIsAuth(context);
  }

  void checkIfUserIsAuth(BuildContext context) async {
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
          
      Navigator.of(context).pushNamedAndRemoveUntil('/navigation', (_) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }
}
