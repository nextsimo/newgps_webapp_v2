import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';

class DateTimePicker extends StatelessWidget {
  final double width;
  final DateTime dateFrom;
  final DateTime dateTo;

  final void Function() onTapDateTo;
  final void Function() onTapDateFrom;
  final void Function() onTapTime;
  const DateTimePicker({
    super.key,
    required this.width,
    required this.dateFrom,
    required this.dateTo,
    required this.onTapDateTo,
    required this.onTapDateFrom,
    required this.onTapTime,
  });

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeFrom =
        TimeOfDay(hour: dateFrom.hour, minute: dateFrom.minute);
    TimeOfDay timeTo = TimeOfDay(hour: dateTo.hour, minute: dateTo.minute);
    return Container(
      width: width,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppConsts.mainColor,
          width: AppConsts.borderWidth,
        ),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onTapDateFrom,
                      child: Text(
                        'Du ${formatSimpleDate(dateFrom)}',
                        textAlign: TextAlign.center,
   
                      ),
                    ),
                  ),
                  Container(
                    width: 1.1,
                    color: Colors.green,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onTapDateTo,
                      child: Text(
                        'Au ${formatSimpleDate(dateTo)}',
                        textAlign: TextAlign.center,
   
                      ),
                    ),
                  ),
                ],
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
                    '${converTo2Digit(timeFrom.hour)}:${converTo2Digit(timeFrom.minute)} à ${converTo2Digit(timeTo.hour)}:${converTo2Digit(timeTo.minute)}',
  
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
