import 'package:flutter/material.dart';
import 'package:newgps/src/models/repport_resume_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/resume/resume_repport_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../rapport_provider.dart';
import '../text_cell.dart';

class BuildHead extends StatelessWidget {
  const BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    ResumeRepportProvider repportProvider =
        Provider.of<ResumeRepportProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            'N',
            flex: 1,
            ontap: repportProvider.updateOrderByNumber,
            isSlected: repportProvider.selectedIndex == 0,
            isUp: repportProvider.orderByNumber,
          ),
          const BuildDivider(),
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
            'Cons L/100',
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
            flex: 4,
            ontap: repportProvider.updateByAdresse,
            isSlected: repportProvider.selectedIndex == 10,
            isUp: repportProvider.orderByAdresse,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Ville',
            flex: 2,
            ontap: repportProvider.updateByCity,
            isSlected: repportProvider.selectedIndex == 11,
            isUp: repportProvider.orderByCity,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Date actualisation',
            flex: 4,
            ontap: repportProvider.updateByDateActualisation,
            isSlected: repportProvider.selectedIndex == 12,
            isUp: repportProvider.orderByDateActualisation,
          ),
          const BuildDivider(),
          const SizedBox(
              width: 126,
              child: Center(
                child: Text(
                  'Redémarrer boitier',
                ),
              )),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class ResumeRepport extends StatelessWidget {
  const ResumeRepport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RepportProvider repportProvider = Provider.of(context, listen: false);
    return ChangeNotifierProvider<ResumeRepportProvider>(
        create: (__) => ResumeRepportProvider(repportProvider),
        builder: (context, snapshot) {
          ResumeRepportProvider resumeRepportProvider =
              Provider.of<ResumeRepportProvider>(context);
          List<RepportResumeModel> resumes = resumeRepportProvider.resumes;
          return StreamBuilder(
            stream: Stream.periodic(
                const Duration(seconds: 7),
                (_) => resumeRepportProvider.fetch(
                    deviceID: repportProvider.selectedDevice.deviceId,
                    repportProvider: repportProvider)),
            builder: (_, __) {
              return _BuildTable(resumes: resumes);
            },
          );
        });
  }
}

class _BuildTable extends StatelessWidget {
  const _BuildTable({
    Key? key,
    required this.resumes,
  }) : super(key: key);

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
    Key? key,
    required this.repport,
  }) : super(key: key);

  final RepportResumeModel repport;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildTextCell('${repport.index}', flex: 1),
          const BuildDivider(),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
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
                                label: repport.phone1,
                              ),
                              const SizedBox(height: 10),
                              if (repport.phone2.isNotEmpty)
                                MainButton(
                                  onPressed: () {},
                                  icon: Icons.phone_forwarded_rounded,
                                  label: repport.phone2,
                                ),
                            ],
                          ),
                        ),
                      );
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
          BuildTextCell(repport.adresse, flex: 4),
          const BuildDivider(),
          BuildTextCell(repport.city, flex: 2),
          const BuildDivider(),
          BuildTextCell(formatDeviceDate(repport.lastValideDate), flex: 4),
          const BuildDivider(),
          Padding(
            padding: const EdgeInsets.all(3),
            child: MainButton(
              width: 120,
              onPressed: () {},
              label: 'Redémarrer',
              backgroundColor: Colors.green,
              height: 30,
            ),
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}
