import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'src/utils/configure_web.dart';
import 'src/utils/locator.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

Future<void> main() async {
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}){};
  }
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  runApp(const NewGpsApp());
}
