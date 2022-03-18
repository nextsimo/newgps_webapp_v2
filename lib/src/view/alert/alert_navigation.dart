import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/alert/capot/capot_view.dart';
import 'package:newgps/src/view/alert/temperature/temperature_view.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'alert_view.dart';
import 'battery/battery_view.dart';
import 'depranch/depranch_notif_view.dart';
import 'fuel/fuel_view.dart';
import 'highway/nighway_notif_view.dart';
import 'hsitorics/notif_hsitoric_view.dart';
import 'kilometrage/kilometrage_view.dart';
import 'radar/radar_view.dart';
import 'speed/speed_view.dart';

class AlertNavigation extends StatelessWidget {
  const AlertNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Navigator(
          initialRoute: deviceProvider.initAlertRoute,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/speed':
                return MaterialPageRoute(
                    builder: (_) => const SpeedAlertView());
                case '/historics':
                  return MaterialPageRoute(
                      builder: (_) => const NotifHistoricView());
              case '/capot':
                return MaterialPageRoute(builder: (_) => const CapoView());
              case '/temp':
                return MaterialPageRoute(
                    builder: (_) => const TemperatureView());
              case '/radar':
                return MaterialPageRoute(
                    builder: (_) => const RadarNotifView());
              case '/fuel':
                return MaterialPageRoute(builder: (_) => const FuelAlertView());
              case '/odometre':
                return MaterialPageRoute(
                    builder: (_) => const KilometrageNotifView());
              case '/debranchement':
                return MaterialPageRoute(
                    builder: (_) => const DepranchNotifView());
              case '/battery':
                return MaterialPageRoute(
                    builder: (_) => const BatteryAlertView());
              case '/highway':
                return MaterialPageRoute(
                    builder: (_) => const HighwayNotifView());
              default:
                return MaterialPageRoute(builder: (_) => const AlertView());
            }
          },
        ),
        const _BuildMapWidget(),
      ],
    );
  }
}

class _BuildMapWidget extends StatelessWidget {
  const _BuildMapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      right: AppConsts.outsidePadding,
      top: 60,
      child: LogoutButton(),
    );
  }
}
