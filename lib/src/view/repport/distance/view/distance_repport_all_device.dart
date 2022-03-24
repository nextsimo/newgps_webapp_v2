import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../models/device.dart';
import '../../../../utils/styles.dart';
import '../../clickable_text_cell.dart';
import '../../custom_devider.dart';
import '../../rapport_provider.dart';
import '../../text_cell.dart';
import '../models/repport_distance_model.dart';
import '../provider/distance_provider.dart';

class DistanceRepportAllDeviceView extends StatefulWidget {
  const DistanceRepportAllDeviceView({Key? key}) : super(key: key);

  @override
  State<DistanceRepportAllDeviceView> createState() =>
      _DistanceRepportAllDeviceViewState();
}

class _DistanceRepportAllDeviceViewState
    extends State<DistanceRepportAllDeviceView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context, listen: false);

    provider.initContrtoller(_scrollController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.select<RepportProvider, Device>((p) => p.selectedDevice);
    context.select<RepportProvider, DateTime>((p) => p.dateFrom);
    context.select<RepportProvider, DateTime>((p) => p.dateTo);    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context, listen: false);
    provider.fetchForAllDevices(p: 1);

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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                                "${provider.distanceSum == 0 ? '...' : provider.distanceSum}",
                                style:  GoogleFonts.roboto(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        itemCount: provider.repport.repports.length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                            model: provider.repport.repports.elementAt(index),
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
  const _BuildHead({
    Key? key,
  }) : super(key: key);

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
            'Matricule',
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
    Key? key,
    required this.model,
  }) : super(key: key);

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
          BuildTextCell(model.description),
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
