import 'package:firebase_remote_config/firebase_remote_config.dart';

class Utils {
  // init firbase config
  static void initFirebaseConfig() {
    FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  // define base url
  static String baseUrl = 'https://api.newgps.ma/api/auth';
}
