import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import '../models/device.dart';
import '../utils/styles.dart';

class ShowDeviceDialogWidget extends StatelessWidget {
  final void Function(Device device) onselectedDevice;
  final String label;
  const ShowDeviceDialogWidget(
      {super.key, required this.onselectedDevice, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: _DevicesDialog(
                  onselectedDevice: onselectedDevice,
                ),
              );
            });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        //margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppConsts.mainColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), const Icon(Icons.arrow_drop_down_outlined)],
        ),
      ),
    );
  }
}

class _DevicesDialog extends StatefulWidget {
  final void Function(Device device) onselectedDevice;

  const _DevicesDialog({required this.onselectedDevice});

  @override
  State<_DevicesDialog> createState() => _DevicesDialogState();
}

class _DevicesDialogState extends State<_DevicesDialog> {
  List<Device> _devices = deviceProvider.devices;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchWidget(
                  onChnaged: (_) {
                    if (_.isEmpty) {
                      _devices = deviceProvider.devices;
                    } else {
                      _devices = deviceProvider.devices
                          .where((e) => e.description
                              .toLowerCase()
                              .contains(_.toLowerCase()))
                          .toList();
                    }

                    setState(() {});
                  },
                  hint: 'Rechercher',
                ),
              ),
              const CloseButton(),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (_, int index) {
                  Device device = _devices.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onselectedDevice(device);
                    },
                    title: Text(
                      device.description,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
