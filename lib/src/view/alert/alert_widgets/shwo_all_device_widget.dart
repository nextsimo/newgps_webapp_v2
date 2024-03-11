import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/styles.dart';
import 'select_devices_view.dart';

class ShowAllDevicesWidget extends StatelessWidget {
  final Future<void> Function(List<String>) onSaveDevices;
  final List<String> selectedDevices;
  final bool shortText;
  const ShowAllDevicesWidget(
      {super.key,
      required this.onSaveDevices,
      this.selectedDevices = const [],
      this.shortText = false});

  @override
  Widget build(BuildContext context) {
    selectedDevices.remove('all');
    selectedDevices.remove('');
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: SelectDeviceUi(
                  onSaveDevices: onSaveDevices,
                  initSelectedDevice: selectedDevices,
                ),
              );
            });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppConsts.mainColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!shortText)
              Text(
                  'Sélectionner les véhicules ${selectedDevices.isEmpty ? '' : "(${selectedDevices.length})"}'),
            if (shortText)
              Text(
                'Véhicules ${"(${selectedDevices.length})"}',
                style:  GoogleFonts.roboto(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        ),
      ),
    );
  }
}
