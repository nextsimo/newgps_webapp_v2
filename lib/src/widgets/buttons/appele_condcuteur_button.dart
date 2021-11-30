import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import 'log_out_button.dart';
import 'main_button.dart';

class AppelCondicteurButton extends StatelessWidget {
  final Device device;
  const AppelCondicteurButton({
    Key? key,
    required this.device,
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
          if (device.phone1.isNotEmpty)
            Consumer<DeviceProvider>(builder: (_, ___, ____) {
              return MainButton(
                width: 150,
                height: 35,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(17),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MainButton(
                                  onPressed: () {},
                                  icon: Icons.phone_forwarded_rounded,
                                  label: device.phone1,
                                ),
                                const SizedBox(height: 10),
                                if (device.phone2.isNotEmpty)
                                  MainButton(
                                    onPressed: () {},
                                    icon: Icons.phone_forwarded_rounded,
                                    label: device.phone2,
                                  ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                label: 'Appel conducteur',
              );
            }),
        ],
      ),
    );
  }
}