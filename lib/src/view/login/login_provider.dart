import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

import '../connected_device/connected_device_provider.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController compteController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController underCompteController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  late String _errorText = '';

  String get errorText => _errorText;

  set errorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

    bool isUnderCompte = false;

  // set under user checkbox value
  void setUnderCompte(bool? value) {
    if (value != null) {
      underCompteController.text = '';
      isUnderCompte = value;
      notifyListeners();
    }
  }

  Future<void> updatePassword(BuildContext context) async {
    if (updateFormKey.currentState!.validate()) {
      String res = await api.simplePost(
        url: '/update/password',
        body: <String, String>{
          'accountId': compteController.text,
          'oldPassword': passwordController.text,
          'newPassword': newPasswordController.text,
        },
      );

      var data = json.decode(res);

      if (data['code'] == 200) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Icon(
              Icons.check_circle_sharp,
              color: Colors.green,
            ),
            content: Text('Mote de passe change avec succes'),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Icon(
            Icons.dangerous,
            color: Colors.orange,
          ),
          content: Text(data['message']),
        ),
      );
    }
  }

  Future<void> login(BuildContext context) async {
    errorText = '';
    if (formKey.currentState!.validate()) {
      // request login

      if (underCompteController.text.isNotEmpty) {
        await underAccountLogin(context);

        return;
      }

      Account? account = await api.login(
        accountId: compteController.text,
        password: passwordController.text,
      );
      if (account != null) {
        final LastPositionProvider lastPositionProvider =
            Provider.of<LastPositionProvider>(context, listen: false);
        final SavedAcountProvider savedAcountProvider =
            Provider.of<SavedAcountProvider>(context, listen: false);
        savedAcountProvider.initUserDroit();
        savedAcountProvider.savedAcount(
            account.account.accountId, passwordController.text, );
        await shared.saveAccount(Account(
            account: AccountClass(
                accountId: compteController.text,
                userID: underCompteController.text,
                password: passwordController.text,
                description: account.account.description),
            token: passwordController.text));
        fetchInitData(
            lastPositionProvider: lastPositionProvider, context: context);
        compteController.text = '';
        passwordController.text = '';
        final ConnectedDeviceProvider connectedDeviceProvider =
            // ignore: use_build_context_synchronously
            Provider.of<ConnectedDeviceProvider>(context, listen: false);
        connectedDeviceProvider.init();
        connectedDeviceProvider.createNewConnectedDeviceHistoric(true);
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/navigation', (_) => false);
      } else {
        errorText = 'Mot de passe ou account est inccorect';
      }
    }
  }

  Future<void> underAccountLogin(BuildContext context) async {
    errorText = '';
    // request login
    Account? account = await api.underAccountLogin(
      accountId: compteController.text,
      password: passwordController.text,
      underAccountLogin: underCompteController.text,
    );
    if (account != null) {
      final SavedAcountProvider savedAcountProvider =
          Provider.of<SavedAcountProvider>(context, listen: false);
      final LastPositionProvider lastPositionProvider =
          Provider.of<LastPositionProvider>(context, listen: false);
      savedAcountProvider.savedAcount(
        account.account.accountId,
        passwordController.text,
        account.account.userID,
      );
      shared.saveAccount(account);
      await savedAcountProvider.fetchUserDroits();

      fetchInitData(
          context: context, lastPositionProvider: lastPositionProvider);
      final ConnectedDeviceProvider connectedDeviceProvider =
          Provider.of<ConnectedDeviceProvider>(context, listen: false);
      connectedDeviceProvider.init();
      connectedDeviceProvider.createNewConnectedDeviceHistoric(true);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/navigation', (route) => false);
    } else {
      errorText = 'Mot de passe ou account est inccorect';
    }
  }
}
