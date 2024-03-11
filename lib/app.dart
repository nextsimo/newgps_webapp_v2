import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/login/login_provider.dart';
import 'package:newgps/src/view/login/login_view.dart';
import 'package:newgps/src/view/navigation/navigation_view.dart';
import 'package:newgps/src/view/splash/splash_view.dart';
import 'package:provider/provider.dart';
import 'src/view/connected_device/connected_device_provider.dart';
import 'src/view/historic/historic_provider.dart';
import 'src/view/login/login_as/save_account_provider.dart';

class NewGpsApp extends StatelessWidget {
  const NewGpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceProvider>.value(value: deviceProvider),
        ChangeNotifierProvider<LastPositionProvider>(
            create: (_) => LastPositionProvider()),
        ChangeNotifierProvider<HistoricProvider>(
            create: (_) => HistoricProvider()),
        ChangeNotifierProvider<SavedAcountProvider>(
          create: (_) => SavedAcountProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<ConnectedDeviceProvider>(
            create: (_) => ConnectedDeviceProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const SplashView(),
          '/navigation': (context) => CustomNavigationView(),
          '/login': (context) => const LoginView(),
          '/alert': (context) => const SplashView(alert: true),
          // When navigating to the "/second" route, build the SecondScreen widget.
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr')],
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        title: 'NEW GPS',
        theme: ThemeData(
          //textTheme: GoogleFonts.amiriTextTheme(),
          primaryColor: AppConsts.mainColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => AppConsts.mainColor)),
          ),
        ),
      ),
    );
  }
}
