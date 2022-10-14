import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../../services/newgps_service.dart';
import '../../view/connected_device/connected_device_provider.dart';
import 'audio_widget.dart';

class LogoutButton extends StatelessWidget {
  final double witdh;
  const LogoutButton({Key? key, this.witdh = 150}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VolumeWidget(),
        const SizedBox(width: 5),
        MainButton(
          height: 30,
          onPressed: () {
            shared.clear('account');

            ConnectedDeviceProvider connectedDeviceProvider =
                Provider.of(context, listen: false);
            connectedDeviceProvider.updateConnectedDevice(false);
            connectedDeviceProvider.createNewConnectedDeviceHistoric(false);
            Phoenix.rebirth(context);

/*             try {
              LastPositionProvider lastPositionProvider =
                  Provider.of(context, listen: false);
              HistoricProvider historicProvider =
                  Provider.of(context, listen: false);
              lastPositionProvider.fresh();
              historicProvider.fresh();
            } catch (e) {
              //debugPrint(e.toString());
            }

            ConnectedDeviceProvider connectedDeviceProvider =
                Provider.of(context, listen: false);
            connectedDeviceProvider.updateConnectedDevice(false);
            connectedDeviceProvider.createNewConnectedDeviceHistoric(false);
            shared.clear('account');

            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (_) => false); */
          },
          label: 'Deconnexion',
          backgroundColor: Colors.red,
          width: witdh,
        ),
      ],
    );
  }
}
