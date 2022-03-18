import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/appele_condcuteur_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class GroupedButton extends StatelessWidget {
  const GroupedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LastPositionProvider provider =
        Provider.of<LastPositionProvider>(context);

    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);



    if (!provider.fetchAll) {
      return AppelCondicteurButton(
        device: deviceProvider.selectedDevice,
        callNewData: () async =>
            await provider.fetchDevice(deviceProvider.selectedDevice.deviceId),
      );
    }
    return Positioned(
      right: AppConsts.outsidePadding,
      top: 50,
      child: Column(children: [
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: 30,
              width: 150,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.onClickRegoupement(!clicked);
              },
              label: 'Regrouper',
            );
          },
          selector: (_, p) => p.regrouperClicked,
        ),
        const SizedBox(height: 5),
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: 30,
              width: 150,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.onClickMatricule(!clicked);
              },
              label: 'Matricule',
            );
          },
          selector: (_, p) => p.matriculeClicked,
        ),
        const SizedBox(height: 5),
        Selector<LastPositionProvider, bool>(
          builder: (_, bool clicked, __) {
            return MainButton(
              borderColor: AppConsts.mainColor,
              height: 30,
              width: 150,
              textColor: clicked ? AppConsts.mainColor : Colors.white,
              backgroundColor: clicked ? Colors.white : AppConsts.mainColor,
              onPressed: () {
                provider.ontraficClicked(!clicked);
              },
              label: 'Trafic',
            );
          },
          selector: (_, p) => p.traficClicked,
        ),
      ]),
    );
  }
}
