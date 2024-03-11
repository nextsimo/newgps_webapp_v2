import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:newgps/src/models/repports_details_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/details/repport_details_provider.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';

class RepportDetailsView extends StatelessWidget {
  const RepportDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RepportDetailsProvider>(
      create: (_) => RepportDetailsProvider(
          Provider.of<RepportProvider>(context, listen: false)),
      builder: (context, __) {
        RepportProvider provider = Provider.of<RepportProvider>(context);
        RepportDetailsProvider repportDetailsProvider =
            Provider.of<RepportDetailsProvider>(context, listen: false);
        repportDetailsProvider.fetchRepportModel(
            deviceId: provider.selectedDevice.deviceId,
            newDateFrom: provider.dateFrom,
            newDateTo: provider.dateTo);
        return Material(
          child: Column(
            children: [
              const _BuildHead(),
              Consumer2<RepportDetailsProvider, RepportProvider>(
                  builder: (context, __, ___, ____) {
                return Expanded(
                  child: LoadMore(
                    isFinish: repportDetailsProvider
                            .repportDetailsPaginateModel.currentPage >
                        repportDetailsProvider
                            .repportDetailsPaginateModel.lastPage,
                    textBuilder: (status) {
                      return "";
                    },
                    onLoadMore: () async {
                      await repportDetailsProvider.fetchMoreRepportModel(
                          provider,
                          deviceId: provider.selectedDevice.deviceId);

                      return true;
                    },
                    child: ListView.builder(
                      itemCount: repportDetailsProvider
                          .repportDetailsPaginateModel
                          .repportsDetailsModel
                          .length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                            repport: repportDetailsProvider
                                .repportDetailsPaginateModel
                                .repportsDetailsModel
                                .elementAt(index));
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead();

  @override
  Widget build(BuildContext context) {
    RepportDetailsProvider repportDetailsProvider =
        Provider.of<RepportDetailsProvider>(context);
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
            flex: 2,
            index: 0,
            ontap: repportDetailsProvider.onTap,
            isSlected: 0 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Heure',
            flex: 2,
            index: 1,
            ontap: repportDetailsProvider.onTap,
            isSlected: 1 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Adresse',
            flex: 4,
            index: 2,
            ontap: repportDetailsProvider.onTap,
            isSlected: 2 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Statut',
            flex: 2,
            ontap: repportDetailsProvider.onTap,
            index: 3,
            isSlected: 3 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Vitesse',
            flex: 2,
            index: 4,
            ontap: repportDetailsProvider.onTap,
            isSlected: 4 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km actuel',
            flex: 2,
            index: 5,
            ontap: repportDetailsProvider.onTap,
            isSlected: 5 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Niveau carburant (L)',
            flex: 2,
            index: 6,
            ontap: repportDetailsProvider.onTap,
            isSlected: 6 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Niveau carburant (%)',
            flex: 2,
            index: 7,
            ontap: repportDetailsProvider.onTap,
            isSlected: 7 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Total carburant (L)',
            flex: 2,
            index: 8,
            ontap: repportDetailsProvider.onTap,
            isSlected: 8 == repportDetailsProvider.selectedIndex,
            isUp: repportDetailsProvider.up,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  const _RepportRow({
    required this.repport,
  });

  final RepportsDetailsModel repport;

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
          BuildTextCell(formatSimpleDate(repport.timestamp), flex: 2),
          const BuildDivider(),
          BuildTextCell(formatToTimeWithSeconds(repport.timestamp), flex: 2),
          const BuildDivider(),
          BuildTextCell(repport.address, flex: 4),
          const BuildDivider(),
          BuildTextCell(repport.statut, flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.speedKph}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.odometerKM}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelRemain}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelLevel}', flex: 2),
          const BuildDivider(),
          BuildTextCell('${repport.fuelTotal}', flex: 2),
          const BuildDivider(),
        ],
      ),
    );
  }
}
