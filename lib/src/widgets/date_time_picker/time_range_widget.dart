import 'package:flutter/material.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/date_time_picker/time_input.dart';

class TimeRangeWigdet extends StatelessWidget {
  final dynamic provider;
  final void Function() onSave;
  final void Function() onRestaure;

  const TimeRangeWigdet(
      {super.key,
      required this.provider,
      required this.onSave,
      required this.onRestaure});

  @override
  Widget build(BuildContext context) {
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
            Text('De', style: Theme.of(context).textTheme.labelLarge),
            Text('à', style: Theme.of(context).textTheme.labelLarge),
          ]),
          const SizedBox(height: 15),
          Row(
            children: [
              TimeInput(
                dateTime: provider.selectedTimeFrom,
                isDateFrom: true,
                provider: provider,
              ),
              const SizedBox(width: 16),
              TimeInput(
                dateTime: provider.selectedTimeTo,
                isDateFrom: false,
                provider: provider,
              ),
            ],
          ),
          const SizedBox(height: 15),
          MainButton(
            onPressed: onSave,
            label: 'Enregistrer',
            width: 160,
          ),
          const SizedBox(height: 10),
          MainButton(
            onPressed: onRestaure,
            label: "Restaurer l'heure",
            width: 160,
          ),
        ],
      ),
    );
  }
}
