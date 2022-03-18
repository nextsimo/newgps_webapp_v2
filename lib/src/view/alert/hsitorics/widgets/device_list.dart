import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

import '../notif_historic_provider.dart';

class DeviceListNotifHistoric extends StatefulWidget {
  final BuildContext gContext;
  const DeviceListNotifHistoric({Key? key, required this.gContext})
      : super(key: key);

  @override
  State<DeviceListNotifHistoric> createState() =>
      _DeviceListNotifHistoricState();
}

class _DeviceListNotifHistoricState extends State<DeviceListNotifHistoric> {
  List<Device> _devices = [];
  late DeviceProvider provider;
  late NotifHistoricPorvider notifHistoricPorvider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<DeviceProvider>(context, listen: false);
    _devices = provider.devices;
    notifHistoricPorvider =
        Provider.of<NotifHistoricPorvider>(widget.gContext, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SearchWidget(
              onChnaged: (String res) {
                if (res.isEmpty) {
                  _devices = provider.devices;
                } else {
                  _devices = _devices
                      .where((e) => e.description
                          .toLowerCase()
                          .contains(res.toLowerCase()))
                      .toList();
                }
                setState(() {});
              },
            ),
            MainButton(
              width: 100,
              height: 29,
              onPressed: () {
                Navigator.of(context).pop();
                notifHistoricPorvider.notif();
              },
              label: 'Appliquer',
            ),
            CloseButton(
              onPressed: () {
                Navigator.of(context).pop();
                notifHistoricPorvider.initDevices(widget.gContext);
              },
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          children: _devices.map<Widget>((device) {
            bool isSelected =
                notifHistoricPorvider.selectedDevices.contains(device.deviceId);
            return InkWell(
              onTap: () => _ontapDevice(isSelected, device),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _ontapDevice(isSelected, device),
                  ),
                  Text(
                    device.description,
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _ontapDevice(bool isSelected, Device device) {
    if (isSelected) {
      notifHistoricPorvider.selectedDevices.remove(device.deviceId);
    } else {
      notifHistoricPorvider.selectedDevices.add(device.deviceId);
    }
    setState(() {});
  }
}
