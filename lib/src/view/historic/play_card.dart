import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/historic/speed_status_histo.dart';
import 'package:provider/provider.dart';

class PlayCard extends StatelessWidget {
  const PlayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider = Provider.of<HistoricProvider>(context);
    Device? device = provider.selectedPlayData;
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    if (device == null) return const SizedBox();
    return Container(
      width: 500,
      margin: const EdgeInsets.all(AppConsts.outsidePadding),
      padding: const EdgeInsets.all(AppConsts.outsidePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpeedStatusHisto(),
          const SizedBox(height: 12),
          Center(
            child: Text(
              deviceProvider.selectedDevice.description,
              style:  GoogleFonts.roboto(color: Colors.blue,fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconLabel(
                      icon: Icons.car_repair,
                      label: device.statut,
                      title: 'Etat'),
                  const SizedBox(height: 10),
                  _buildIconLabel(
                      icon: Icons.date_range,
                      label: formatDeviceDate(device.dateTime),
                      title: 'Date'),
                ],
              ),
             Container(
               margin: const EdgeInsets.symmetric(horizontal: 8),
               width: 1.5,
               color: Colors.grey[300],
               height: 40,

             ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconLabel(
                      icon: Icons.speed,
                      label: '${device.speedKph.toInt()} Km/h',
                      title: 'Vitesse'),
                  const SizedBox(height: 10),
                  _buildIconLabel(
                      icon: Icons.wysiwyg_sharp,
                      label: '${device.odometerKm.toInt()} Km',
                      title: 'Kilométrage'),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.8,
            color: AppConsts.mainColor,
          )),
    );
  }

  Widget _buildIconLabel(
      {required String label, required IconData icon, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppConsts.mainColor,
        ),
        const SizedBox(width: 6),
        Text(
          '$title:',
          style:  GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
