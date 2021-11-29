import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/speed_alert_model.dart';
import 'package:newgps/src/services/newgps_service.dart';

class SpeedAlertProvider with ChangeNotifier {
  SpeedAlertModel? model;
  bool _loading = false;
  bool _active = false;

  bool get active => _active;

  set active(bool active) {
    _active = active;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  final TextEditingController controller = TextEditingController();

  SpeedAlertProvider() {
    fetchSpeedParam();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTap() {
    _selectText();
  }

  Future<void> onTapSwitch(bool val) async {
    Account? account = shared.getAccount();
    await api.post(
      url: '/notification/updatestate',
      body: {'account_id': account!.account.accountId, 'is_active': val},
    );
    active = val;
  }

  Future<void> onTapSaved() async {
    _setTextController(controller.text);

    await _updateMaxSpeed(double.parse(controller.text.split(' ').first));
  }

  Future<void> _updateMaxSpeed(double speedLimit) async {
    Account? account = shared.getAccount();

    await api.post(
      url: '/notification/updatespeedlimit',
      body: {
        'account_id': account?.account.accountId,
        'speed_limit': speedLimit,
      },
    );
  }

  void _setTextController(String text) {
    String newText = text.split(' ').first;
    controller.text = '$newText Km/h';
    _selectText();
  }

  void _selectText() {
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }

  Future<void> fetchSpeedParam() async {
    _loading = false;
    Account? account = shared.getAccount();

    String res = await api.post(url: '/notification/settings', body: {
      'account_id': account?.account.accountId,
    });
    model = notificationSettingFromJson(res).first;
    _setTextController(model!.speedLimit.toString());
    active = model!.isActive;
    loading = true;
  }


}
