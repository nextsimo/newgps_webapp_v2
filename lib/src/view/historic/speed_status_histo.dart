import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class SpeedStatusHisto extends StatelessWidget {
  const SpeedStatusHisto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider = Provider.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: AppConsts.mainColor,
              borderRadius: BorderRadius.circular(AppConsts.mainradius)),
          child: Center(
            child: IconButton(
                onPressed: provider.playPause,
                icon: Icon(
                  provider.play ? Icons.pause_outlined : Icons.play_arrow,
                  color: Colors.white,
                )),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(4, (index) {
          return InkWell(
            onTap: () => provider.ontapSpeed(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: provider.selectedIndex == index
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(AppConsts.mainradius)),
              child: Center(
                child: Text(
                  'x ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          );
        })
      ],
    );
  }
}
