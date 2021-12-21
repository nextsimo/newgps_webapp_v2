import 'package:flutter/material.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import 'audio_widget.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VolumeWidget(),
        const SizedBox(width: 10),
        MainButton(
          height: 30,
          onPressed: () {
            try {
              LastPositionProvider lastPositionProvider =
                  Provider.of(context, listen: false);
              HistoricProvider historicProvider =
                  Provider.of(context, listen: false); 
              lastPositionProvider.fresh();
              historicProvider.fresh();
            } catch (e) {
              debugPrint(e.toString());
            }
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (_) => false);
          },
          label: 'Deconnexion',
          backgroundColor: Colors.red,
          width: 150,
        ),
      ],
    );
  }
}
