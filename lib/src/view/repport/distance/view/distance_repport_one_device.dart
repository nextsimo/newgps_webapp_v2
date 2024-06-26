import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:provider/provider.dart';
import '../../../../utils/styles.dart';
import '../../clickable_text_cell.dart';
import '../../custom_devider.dart';
import '../../rapport_provider.dart';
import '../../text_cell.dart';
import '../models/repport_distance_model.dart';
import '../provider/distance_provider.dart';

class DistanceRepportOneDevice extends StatelessWidget {
  const DistanceRepportOneDevice({super.key});

  @override
  Widget build(BuildContext context) {
    context.select<RepportProvider, Device>((p) => p.selectedDevice);
    context.select<RepportProvider, DateTime>((p) => p.dateFrom);
    context.select<RepportProvider, DateTime>((p) => p.dateTo);
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context, listen: false);
    provider.fetchOnDevice();

    return Material(
      child: SafeArea(
        right: false,
        bottom: false,
        top: false,
        child: Column(
          children: [
            const _BuildHead(),
            Expanded(
              child: Consumer<DistanceRepportProvider>(
                  builder: (context, provider, _) {
                return Column(
                  children: [
                    if (provider.repportsPerDevice.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                          color: AppConsts.mainColor,
                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Expanded(
                              child: Center(
                                child: Text(
                                  'Total distance parcorue:',
                                  style: GoogleFonts.roboto(color: Colors.white),
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            const Expanded(child: SizedBox()),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "${provider.totalDistance}",
                                  style:  GoogleFonts.roboto(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: provider.repportsPerDevice.length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                            model: provider.repportsPerDevice.elementAt(index),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead();

  @override
  Widget build(BuildContext context) {
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context);
    var borderSide = const BorderSide(
        color: Colors.black, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            'Date',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(0),
            isUp: provider.up,
            index: 0,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km départ',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(1),
            isUp: provider.up,
            index: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km fin',
            ontap: provider.orderByClick,
            isUp: provider.up,
            index: 2,
            isSlected: provider.isSelected(2),
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Distance parcorue(Km)',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(3),
            isUp: provider.up,
            index: 3,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  final Repport model;
  const _RepportRow({
    required this.model,
  });

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
          const BuildDivider(),
          BuildTextCell(formatSimpleDate(model.date)),
          const BuildDivider(),
          BuildTextCell('${model.startKm}'),
          const BuildDivider(),
          BuildTextCell('${model.endKm}'),
          const BuildDivider(),
          BuildTextCell('${model.distance}'),
          const BuildDivider(),
        ],
      ),
    );
  }
}
