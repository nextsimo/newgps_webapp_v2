import 'package:flutter/material.dart';
import '../../../utils/styles.dart';
import 'time_input.dart';
import '../historic_provider.dart';
import '../../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class TimeRangeWigdet extends StatelessWidget {
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool fetch;
  const TimeRangeWigdet(
      {super.key,
      required this.dateFrom,
      required this.dateTo,
      this.fetch = true});

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(8),
      width: 310,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text('De', style: Theme.of(context).textTheme.labelLarge),
            Text('à', style: Theme.of(context).textTheme.labelLarge),
          ]),
          const SizedBox(height: 8),
          Row(
            children: [
              TimeInput(dateTime: dateFrom, isDateFrom: true),
              const SizedBox(width: 6),
              TimeInput(dateTime: dateTo, isDateFrom: false),
            ],
          ),
          const SizedBox(height: 2),
          MainButton(
            width: 160,
            onPressed: () {
              if (fetch) {
                provider.onTimeRangeSaveClicked();
                provider.fetchHistorics(context, null);
              }
              Navigator.of(context).pop();
              //provider.dateTimeSavedButtonClicked = true;
              //Navigator.of(context).pop();
            },
            label: 'Enregistrer',
          ),
          const SizedBox(height: 4),
          MainButton(
                        width: 160,

            onPressed: () {
              if (fetch) {
                provider.onTimeRangeRestaureClicked();
                provider.fetchHistorics(context, null);
              }
              Navigator.of(context).pop();
/*               provider.notifyDateTime();
              provider.dateTimeSavedButtonClicked = true;
              Navigator.of(context).pop(); */
            },
            label: "Restaurer l'heure",
          ),
        ],
      ),
    );
  }
}
