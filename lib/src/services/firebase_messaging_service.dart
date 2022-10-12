import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';
import 'newgps_service.dart';

class FirebaseMessagingService {
  late int notificationID;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> init() async {
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
    await saveUserMessagingToken();
    _initmessage();
    FirebaseMessaging.onMessage.listen((message) {
      //debugPrint('onMessage');
      acountProvider.checkNotifcation();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //debugPrint('onMessageOpenedApp');
      acountProvider.checkNotifcation();
    });
  }

  Future<void> disableAllSettings(String? account) async {
    String? deviceUID = await getDeviceToken();
    await api.post(
      url: '/disable/alert',
      body: {'account_id': account, 'device_uid': deviceUID, 'state': false},
    );
  }

  Future<void> _initmessage() async {
    RemoteMessage? remoteMessage = await messaging.getInitialMessage();
    if (remoteMessage != null) {
      SavedAcountProvider acountProvider =
          // ignore: use_build_context_synchronously
          Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
      acountProvider.checkNotifcation();
    }
  }

/* 
  Future<void> _init() async {
    SavedAcountProvider acountProvider =
        Provider.of<SavedAcountProvider>(DeviceSize.c, listen: false);
    await saveUserMessagingToken();
    acountProvider.checkNotifcation();
    FirebaseMessaging.onMessage.listen((message) {
      //debugPrint('onMessage');
      acountProvider.checkNotifcation();
    });
/* 
    FirebaseMessaging.onBackgroundMessage((message) async {
      //debugPrint('onBackgroundMessage');
      acountProvider.checkNotifcation();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('onMessageOpenedApp');
      acountProvider.checkNotifcation();

    }); */

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //debugPrint('onMessageOpenedApp');
      acountProvider.checkNotifcation();
    });
  }
 */
  Future<void> saveUserMessagingToken() async {
    await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        criticalAlert: true);

    String? token = await messaging.getToken();
    Account? account = shared.getAccount();
    String? deviceId = await _getDeviceToken();
    // save the new token to database
    log(deviceId.toString());
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
