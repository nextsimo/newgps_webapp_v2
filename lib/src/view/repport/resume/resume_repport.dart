import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/device.dart';
import '../../../models/repport_resume_model.dart';
import '../../../services/newgps_service.dart';
import '../../../utils/functions.dart';
import '../../../utils/locator.dart';
import '../../../utils/styles.dart';
import '../../driver_phone/driver_phone_provider.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../rapport_provider.dart';
import '../text_cell.dart';
import 'loading/resume_repport_loading.dart';
import 'resume_repport_provider.dart';

class BuildHead extends StatelessWidget {
  const BuildHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var borderSide =
        const BorderSide(color: Colors.black, width: AppConsts.borderWidth);
    ResumeRepportProvider repportProvider =
        Provider.of<ResumeRepportProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
/*           BuildClickableTextCell(
            'N',
            flex: 1,
            ontap: repportProvider.updateOrderByNumber,
            isSlected: repportProvider.selectedIndex == 0,
            isUp: repportProvider.orderByNumber,
          ),
          const BuildDivider(), */
          BuildClickableTextCell(
            'Matricule',
            flex: 4,
            ontap: repportProvider.updateOrderByMatricule,
            isSlected: repportProvider.selectedIndex == 1,
            isUp: repportProvider.orderByMatricule,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Chauffeur',
            flex: 2,
            ontap: repportProvider.updateOrderByDriverName,
            isSlected: repportProvider.selectedIndex == 2,
            isUp: repportProvider.orderByDriverName,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km actuel',
            flex: 2,
            ontap: repportProvider.updateByCurrentDistance,
            isSlected: repportProvider.selectedIndex == 3,
            isUp: repportProvider.odrderByCurrentDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Vitesse actuel',
            flex: 2,
            ontap: repportProvider.updateByCurrentSpeed,
            isSlected: repportProvider.selectedIndex == 4,
            isUp: repportProvider.odrderByCurrentSpeed,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Vitesse max',
            flex: 2,
            ontap: repportProvider.updateByMaxSpeed,
            isSlected: repportProvider.selectedIndex == 5,
            isUp: repportProvider.odrderByMaxSpeed,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km parcouru',
            flex: 2,
            ontap: repportProvider.updateByDistance,
            isSlected: repportProvider.selectedIndex == 6,
            isUp: repportProvider.odrderByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Cons L/100Km',
            flex: 2,
            ontap: repportProvider.updateByCarbConsumation,
            isSlected: repportProvider.selectedIndex == 7,
            isUp: repportProvider.orderByCarbConsumation,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'N. carburant',
            flex: 2,
            ontap: repportProvider.updateByCurrentCarb,
            isSlected: repportProvider.selectedIndex == 8,
            isUp: repportProvider.orderByCurrentCarb,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Temps conduite',
            flex: 2,
            ontap: repportProvider.updateDrivingTime,
            isSlected: repportProvider.selectedIndex == 9,
            isUp: repportProvider.orderDrivingTime,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Adresse',
            flex: 8,
            ontap: repportProvider.updateByAdresse,
            isSlected: repportProvider.selectedIndex == 10,
            isUp: repportProvider.orderByAdresse,
          ),
          const BuildDivider(),
/*           BuildClickableTextCell(
            'Ville',
            flex: 2,
            ontap: repportProvider.updateByCity,
            isSlected: repportProvider.selectedIndex == 11,
            isUp: repportProvider.orderByCity,
          ),
          const BuildDivider(), */
          BuildClickableTextCell(
            'Date actualisation',
            flex: 3,
            ontap: repportProvider.updateByDateActualisation,
            isSlected: repportProvider.selectedIndex == 12,
            isUp: repportProvider.orderByDateActualisation,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class ResumeRepport extends StatelessWidget {
  const ResumeRepport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);

    return ChangeNotifierProvider<ResumeRepportProvider>.value(
        value: NewgpsService.resumeRepportProvider,
        builder: (context, snapshot) {
          ResumeRepportProvider resumeRepportProvider =
              Provider.of<ResumeRepportProvider>(context, listen: false);
          resumeRepportProvider.init(repportProvider);

          return Consumer<ResumeRepportProvider>(
            builder: (_, p, __) {
              if (p.resumes.isEmpty) {
                return const ResumeRepportLoading();
              }
              return _BuildTable(resumes: p.resumes);
            },
          );
/*           return Consumer<ResumeRepportProvider>(builder: (context, p, __) {
            return _BuildTable(resumes: p.resumes);
          }); */
        });
  }
}

class _BuildTable extends StatelessWidget {
  const _BuildTable({
    required this.resumes,
  });

  final List<RepportResumeModel> resumes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const BuildHead(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, int index) {
                RepportResumeModel repport = resumes.elementAt(index);
                return RepportRow(repport: repport);
              },
              itemCount: resumes.length,
            ),
          ),
        ],
      ),
    );
  }
}

class RepportRow extends StatelessWidget {
  const RepportRow({
    super.key,
    required this.repport,
  });

  final RepportResumeModel repport;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
/*           const BuildDivider(),
          BuildTextCell('${repport.index}', flex: 1), */
          const BuildDivider(),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                Device device = deviceProvider.devices.firstWhere(
                    (element) => element.deviceId == repport.deviceId);
                locator<DriverPhoneProvider>().checkPhoneDriver(
                    context: context,
                    device: device,
                    sDevice: device,
                    callNewData: () async {
                      await deviceProvider.fetchDevices();
                    });
              },
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    BuildTextCell(repport.description),
                    const Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
          const BuildDivider(),
          BuildTextCell(repport.driverName, flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.lastOdometerKm}', flex: 2),
          const BuildDivider(),
          BuildTextCell(
            '${repport.lastValidSpeedKph}',
            flex: 2,
            color: Color.fromRGBO(
                repport.colorR, repport.colorG, repport.colorB, 1.0),
          ),
          const BuildDivider(),
          BuildTextCell('${repport.maxSpeed}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.distance}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.carbConsomation}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.carbNiveau}', flex: 2),
          const BuildDivider(),
          BuildTextCell(repport.drivingTime, flex: 2),
          const BuildDivider(),
          BuildTextCell(repport.adresse, flex: 8),
          const BuildDivider(),
/*           BuildTextCell(repport.city, flex: 2),
          const BuildDivider(), */
          BuildTextCell(formatDeviceDate(repport.lastValideDate), flex: 3),
/*           const BuildDivider(),
          Padding(
            padding: const EdgeInsets.all(3),
            child: MainButton(
              width: 120,
              onPressed: () {},
              label: 'Redémarrer',
              backgroundColor: Colors.green,
              height: 30,
            ),
          ), */
          const BuildDivider(),
        ],
      ),
    );
  }
}
