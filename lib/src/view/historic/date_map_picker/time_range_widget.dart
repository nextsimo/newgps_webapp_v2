import 'package:flutter/material.dart';
import 'package:newgps/src/view/historic/date_map_picker/time_input.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class TimeRangeWigdet extends StatelessWidget {
  const TimeRangeWigdet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(17),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text('De', style: Theme.of(context).textTheme.button),
            Text('à', style: Theme.of(context).textTheme.button),
          ]),
          const SizedBox(height: 15),
          Row(
            children: [
              TimeInput(dateTime: provider.dateFrom, isDateFrom: true),
              const SizedBox(width: 16),
              TimeInput(dateTime: provider.dateTo, isDateFrom: false),
            ],
          ),
          const SizedBox(height: 15),
          MainButton(
            onPressed: () {
              provider.onTimeRangeSaveClicked();
              provider.fetchHistorics(1, true);
              Navigator.of(context).pop();
              //provider.dateTimeSavedButtonClicked = true;
              //Navigator.of(context).pop();
            },
            label: 'Enregistrer',
          ),
          const SizedBox(height: 10),
          MainButton(
            onPressed: () {
              provider.onTimeRangeRestaureClicked();
              provider.fetchHistorics(1, true);
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
