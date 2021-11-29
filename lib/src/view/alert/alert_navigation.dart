import 'package:flutter/material.dart';
import 'package:newgps/src/view/alert/capot/capot_view.dart';
import 'package:newgps/src/view/alert/temperature/temperature_view.dart';
import 'alert_view.dart';
import 'battery/battery_view.dart';
import 'fuel/fuel_view.dart';
import 'speed/speed_view.dart';

class AlertNavigation extends StatelessWidget {
  const AlertNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/alert',
      onGenerateRoute: (RouteSettings settings) { 
        switch (settings.name) {
          case '/speed':
            return MaterialPageRoute(builder: (_) => const SpeedAlertView());
          case '/capot':
            return MaterialPageRoute(builder: (_) => const CapoView());
          case '/temp':
            return MaterialPageRoute(builder: (_) => const TemperatureView());
          case '/fuel':
            return MaterialPageRoute(builder: (_) => const FuelAlertView());
          case '/battery':
            return MaterialPageRoute(builder: (_) => const BatteryAlertView());
          default:
            return MaterialPageRoute(builder: (_) => const AlertView());
        }
      },
    );
  }
}
