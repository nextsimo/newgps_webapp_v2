import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:provider/provider.dart';

import '../view/historic/date_map_picker/time_range_widget.dart';

class DateHourWidget extends StatelessWidget {
  final double width;
  final void Function()? ontap;
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool fetchData;

  final void Function(DateTime?)? onSelectDate;

  const DateHourWidget(
      {super.key,
      this.width = 400.0,
      this.ontap,
      required this.dateFrom,
      required this.dateTo,
      this.onSelectDate,
      this.fetchData = true});

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
                onTap: () async {
                  var now = DateTime.now();

                  DateTime? datetime = await showDatePicker(
                    context: context,
                    initialDate: dateFrom,
                    firstDate: DateTime(now.year - 30),
                    lastDate: now,
                  );
                  onSelectDate?.call(datetime);
                  if (fetchData) {
                    // ignore: use_build_context_synchronously
                    historicProvider.updateDate(context, datetime);
                  }
                },
                child: Center(
                  child:
                      Text(formatDeviceDate(historicProvider.dateFrom, false)),
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
                onTap: () {
                  if (fetchData) {
                    historicProvider.updateTimeRange(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: TimeRangeWigdet(
                          dateFrom: dateFrom,
                          dateTo: dateTo,
                        ),
                      ),
                    );
                  }
                },
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
