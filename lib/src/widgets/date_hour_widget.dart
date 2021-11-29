import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class DateHourWidget extends StatelessWidget {
  final double width;
  final void Function()? ontap;
  const DateHourWidget({Key? key, this.width = 400.0, this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider historicProvider = Provider.of<HistoricProvider>(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 34,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppConsts.mainColor, width: 1),
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  historicProvider.updateDate(context);
                },
                child: Center(
                  child: Text(
                      formatDeviceDate(historicProvider.dateFrom, false)),
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: 1,
              color: AppConsts.mainColor,
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () => historicProvider.updateTimeRange(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(formatToTime(historicProvider.dateFrom)),
                      ),
                    ),
                    const Text('à'),
                    Expanded(
                      child: Center(
                        child: Text(formatToTime(historicProvider.dateTo)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
