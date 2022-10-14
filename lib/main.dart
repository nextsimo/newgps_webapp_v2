import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'src/utils/configure_web.dart';
import 'src/utils/locator.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

Future<void> main() async {
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}){};
  }
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  runApp(Phoenix(child: const NewGpsApp()));
}
