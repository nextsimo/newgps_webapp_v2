import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';

class DateTimePicker extends StatelessWidget {
  final double width;
  final DateTime dateFrom;
  final DateTime dateTo;


  final void Function() onTapDate;
  final void Function() onTapTime;
  const DateTimePicker({
    Key? key,
    required this.width,
    required this.dateFrom,
    required this.dateTo,required this.onTapDate,required this.onTapTime,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TimeOfDay timeFrom =
        TimeOfDay(hour: dateFrom.hour, minute: dateFrom.minute);
    TimeOfDay timeTo = TimeOfDay(hour: dateTo.hour, minute: dateTo.minute);
    return Container(
      width: width,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppConsts.mainColor,
            width: 1.3,
          )),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTapDate,
                child: Center(
                  child: Text(
                    formatSimpleDate(dateFrom),
                  ),
                ),
              ),
            ),
            Container(
              width: 1.3,
              height: double.infinity,
              color: AppConsts.mainColor,
            ),
            Expanded(
              child: InkWell(
                onTap: onTapTime,
                child: Center(
                  child: Text(
                    ' ${converTo2Digit(timeFrom.hour)}:${converTo2Digit(timeFrom.minute)} à ${converTo2Digit(timeTo.hour)}:${converTo2Digit(timeTo.minute)}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String converTo2Digit(int number) {
  String res = number.toString();
  if (res.length == 1) {
    return res.padLeft(2, '0');
  }
  return res;
}
