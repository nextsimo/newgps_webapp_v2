import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/driver_phone/driver_phone_provider.dart';
import 'package:provider/provider.dart';

import '../../view/historic/parking/parking_button.dart';
import 'log_out_button.dart';
import 'main_button.dart';

class AppelCondicteurButton extends StatelessWidget {
  final Future<void> Function()? callNewData;
  final bool showParkingButton;
  final Device device;
  const AppelCondicteurButton({
    Key? key,
    required this.device,
    this.callNewData,
    required this.showParkingButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppConsts.outsidePadding,
      right: AppConsts.outsidePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const LogoutButton(),
          const SizedBox(height: 2),
          Consumer<DeviceProvider>(builder: (_, ___, ____) {
            return MainButton(
              width: 150,
              height: 35,
              onPressed: () {
                locator<DriverPhoneProvider>().checkPhoneDriver(
                    context: context, device: device, callNewData: callNewData);
              },
              label: 'Appel conducteur',
            );
          }),
          if (showParkingButton)
            const Column(
              children: [
                SizedBox(height: 6),
                ParkingButton(),
              ],
            ),
        ],
      ),
    );
  }
}
