import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/device_provider.dart';
import '../services/location_service.dart';
import '../services/shared_preferences_service.dart';
import '../view/driver_phone/driver_phone_provider.dart';
import '../view/repport/resume/resume_repport_provider.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<LocationService>(LocationService());
  locator.registerSingleton<SharedPrefrencesService>(SharedPrefrencesService());
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<DeviceProvider>(DeviceProvider());
  locator.registerSingleton<FlutterTts>(FlutterTts());
  locator.registerSingleton<DriverPhoneProvider>(DriverPhoneProvider());
  locator.registerSingleton<ResumeRepportProvider>(
      ResumeRepportProvider());
}
