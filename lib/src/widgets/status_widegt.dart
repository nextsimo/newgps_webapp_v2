import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
      ),
      child: Center(
        child: Text(
          device.statut,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
