import 'package:flutter_tts/flutter_tts.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/shared_preferences_service.dart';
import 'package:newgps/src/utils/locator.dart';

import '../view/repport/resume/resume_repport_provider.dart';
import 'api_service.dart';
import 'firebase_messaging_service.dart';
import 'location_service.dart';

class NewgpsService {
  static LocationService locationService = locator<LocationService>();
  static ApiService apiService = locator<ApiService>();
  static SharedPrefrencesService sharedPrefrencesService =
      locator<SharedPrefrencesService>();
  static DeviceProvider deviceProvider = locator<DeviceProvider>();
  static FlutterTts audioPlayer = locator<FlutterTts>();
  static ResumeRepportProvider resumeRepportProvider =
      locator<ResumeRepportProvider>();

  static FirebaseMessagingService messaging =
      locator<FirebaseMessagingService>();
}

LocationService loc = NewgpsService.locationService;
ApiService api = NewgpsService.apiService;
SharedPrefrencesService shared = NewgpsService.sharedPrefrencesService;
DeviceProvider deviceProvider = NewgpsService.deviceProvider;
