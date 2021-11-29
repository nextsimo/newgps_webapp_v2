import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newgps/src/models/account.dart';
import 'newgps_service.dart';

class FirebaseMessagingService {
  late int notificationID;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  FirebaseMessagingService() {
    saveUserMessagingToken();
  }

  Future<void> saveUserMessagingToken() async {
    String? token = await messaging.getToken();

    Account? account = shared.getAccount();

    String? deviceId = await _getDeviceToken();
    // save the new token to database

    String res = await api.post(
      url: '/update/notification',
      body: {
        'accountId': account?.account.accountId,
        'token': token,
        'deviceId': deviceId,
      },
    );
    if (res.isNotEmpty) {
      notificationID = json.decode(res);
    }
    log("Token update $res\nToken : $token");
  }

  Future<String?> _getDeviceToken() async {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    return "${webBrowserInfo.appName}-${webBrowserInfo.platform}-${webBrowserInfo.productSub}";
  }
}
