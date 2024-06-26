import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/fuel_repport_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/fuel/fuel_repport_provider.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../text_cell.dart';

class FuelRepportView extends StatelessWidget {
  const FuelRepportView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FuelRepportProvider>(
      create: (_) => FuelRepportProvider(),
      builder: (context, __) {
        RepportProvider provider =
            Provider.of<RepportProvider>(context, listen: false);
        context.select<RepportProvider, DateTime>((p) => p.dateFrom);
        context.select<RepportProvider, DateTime>((p) => p.dateTo);
        FuelRepportProvider fuelRepportProvider =
            Provider.of<FuelRepportProvider>(context, listen: false);
        fuelRepportProvider.fetchRepports(
            provider.selectedDevice.deviceId, provider);
        context.select<RepportProvider, Device>((p) => p.selectedDevice);

        return Material(
          child: Stack(
            children: [
              Column(
                children: [
                  const _BuildHead(),
                  Consumer<FuelRepportProvider>(
                      builder: (context, __, ____) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: fuelRepportProvider.repports.length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                              repport:
                                  fuelRepportProvider.repports.elementAt(index));
                        },
                      ),
                    );
                  }),
                ],
              ),
            Selector<FuelRepportProvider, bool>(
              selector: (_, p) => p.loading,
              builder: (_, bool loading, __) {
                if (loading) {
                  return const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),


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
    FuelRepportProvider fuelRepportProvider =
        Provider.of<FuelRepportProvider>(context);
    var borderSide = const BorderSide(
        color: Colors.black, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            'Date',
            ontap: fuelRepportProvider.updateDateOrder,
            isSlected: 0 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDate,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Cons. Carburant(L)',
            ontap: fuelRepportProvider.updateFuelConsome,
            isSlected: 1 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByFuelConsom,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Cons. Carburant(L/100KM)',
            ontap: fuelRepportProvider.updateFuelConsome100,
            isSlected: 2 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByFuelConsome100,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Distance parcorue(Km)',
            ontap: fuelRepportProvider.updateByDistance,
            isSlected: 3 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km actuel',
            ontap: fuelRepportProvider.updateByDistance,
            isSlected: 4 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.orderByDistance,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Temps conduite',
            ontap: fuelRepportProvider.updateByDrivingTime,
            isSlected: 5 == fuelRepportProvider.selectedIndex,
            isUp: fuelRepportProvider.oderByDrivingTime,
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

  final FuelRepportData repport;

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
          BuildTextCell(formatSimpleDate(repport.date)),
          const BuildDivider(),
          BuildTextCell('${repport.carbConsomation}'),
          const BuildDivider(),
          BuildTextCell('${repport.carbConsomation100}'),
          const BuildDivider(),
          BuildTextCell('${repport.distance}'),
          const BuildDivider(),
          BuildTextCell('${repport.odometerKM}'),
          const BuildDivider(),
          BuildTextCell(repport.drivingTime),
          const BuildDivider(),
        ],
      ),
    );
  }
}
