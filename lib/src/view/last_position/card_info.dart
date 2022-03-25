import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/info_model.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/status_widegt.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CardInfoView extends StatelessWidget {
  const CardInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);
    InfoModel? infoModel = deviceProvider.infoModel;

    if ((!lastPositionProvider.markersProvider.fetchGroupesDevices && infoModel != null) ||
        (deviceProvider.selectedTabIndex == 1 && infoModel != null)) {
      Device device = deviceProvider.selectedDevice;
      return Positioned(
        bottom: 60,
        left: AppConsts.outsidePadding,
        right:  AppConsts.outsidePadding,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OdometreWidget(device: device),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppConsts.outsidePadding),
                    child: StatusWidget(
                        device: device),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConsts.mainradius),
                  border: Border.all(color: AppConsts.mainColor, width: 1.6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLabel(
                                    label: 'Date',
                                    content: formatDeviceDate(device.dateTime)),
                                const SizedBox(height: 6),
                                _buildLabel(
                                    label: 'Cons carburant',
                                    content:
                                        '${infoModel.carbConsomation.round()} L'),
                              ],
                            ),
                          ),
                          const Cdivider(),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLabel(
                                    label: 'Distance parcourue',
                                    content: '${infoModel.distance} Km'),
                                const SizedBox(height: 6),
                                _buildLabel(
                                    label: 'Vitesse maximal',
                                    content: '${infoModel.maxSpeed} Km/h'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Cdivider(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLabel(
                                  label: 'Kilométrage',
                                  content: '${infoModel.odometer} Km',
                                ),
                                const SizedBox(height: 6),
                                _buildLabel(
                                  label: 'Niveau carburant',
                                  content: '${infoModel.carbNiveau} L',
                                ),
                              ],
                            ),
                          ),
                          const Cdivider(),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLabel(
                                  label: 'Temps de conduite',
                                  content: infoModel.drivingTime,
                                ),
                                const SizedBox(height: 6),
                                _buildLabel(
                                  label: 'Nombre d"arrets',
                                  content: '${infoModel.stopedTime}',
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildLabel({required String label, required String content}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label:',
          ),
        ),
        const SizedBox(width: 10),
        const Text(':'),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Text(
            content,
            style:  GoogleFonts.roboto(
              color: AppConsts.mainColor,
            ),
          ),
        )
      ],
    );
  }
}

class Cdivider extends StatelessWidget {
  const Cdivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 1.7,
      height: 50,
      color: AppConsts.mainColor,
    );
  }
}

class OdometreWidget extends StatelessWidget {
  const OdometreWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-30,0),
      child: SizedBox(
        width: 200,
        height: 100,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  pointers: <RangePointer>[
                    RangePointer(
                      enableDragging: false,
                      value: device.speedKph.toDouble(),
                      color: AppConsts.mainColor,
                      width: 20.5,
                    ),
                  ],
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.35,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Color(0xffA6BBC9),
                  ),
                  startAngle: 180,
                  endAngle: 0,
                  canScaleToFit: true,
                )
              ],
            ),
            Positioned(
              bottom: 4,
              left: 73,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style:  GoogleFonts.roboto(
                    fontSize: 19,
                    color: const Color(0xff639FCE),
                    fontWeight: FontWeight.bold,
                  ),
                  text: '${device.speedKph}\n',
                  children:  [
                    TextSpan(
                      text: 'km/h',
                      style: GoogleFonts.roboto(
                        color: const Color(0xff639FCE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
