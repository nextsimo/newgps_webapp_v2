import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:newgps/src/services/api_service.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/location_service.dart';
import 'package:newgps/src/services/shared_preferences_service.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<LocationService>(LocationService());
  locator.registerSingleton<SharedPrefrencesService>(SharedPrefrencesService());
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<DeviceProvider>(DeviceProvider());
  locator.registerSingleton<FlutterTts>(FlutterTts());
}