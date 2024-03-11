import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:provider/provider.dart';

class MenuDevices extends StatelessWidget {
  const MenuDevices({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);

    List<Device> devices = deviceProvider.devices;

    return Container(
      width: 150,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        itemBuilder: (_, int index) {
          return DeviceListItem(device: devices.elementAt(index));
        },
        itemCount: devices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }
}

class DeviceListItem extends StatelessWidget {
  final Device device;
  const DeviceListItem({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (_) {},
        ),
        const SizedBox(width: 10),
        Text(device.description, style:  GoogleFonts.roboto(fontSize: 10))
      ],
    );
  }
}
