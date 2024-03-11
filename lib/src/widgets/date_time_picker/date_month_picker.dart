import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DateMonthPicker extends StatelessWidget {
  const DateMonthPicker({super.key});

  @override
  Widget build(BuildContext context) {
    RepportProvider provider = Provider.of<RepportProvider>(context);
    return InkWell(
      onTap: () async {
        DateTime? datetTime = await showMonthPicker(
          context: context,
          initialDate: DateTime.now(),
          locale: const Locale('fr', 'FR'),
          lastDate: DateTime.now(),
        );

        //log("$datetTime");
        if (datetTime != null) {
          provider.selectedDateMonth = datetTime;
        }
      },
      child: Container(
        width: 140,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppConsts.mainColor,
            width: 1.3,
          ),
        ),
        child: Center(
            child: Text(
                '${provider.selectedDateMonth.month}/${provider.selectedDateMonth.year}')),
      ),
    );
  }
}
