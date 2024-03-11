import 'package:flutter/material.dart';
import 'package:newgps/src/view/historic/parking/parking_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../historic_provider.dart';

class ParkingButton extends StatelessWidget {
  const ParkingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ParkingProvider>();
    final historicProvider = context.read<HistoricProvider>();
    return Selector<ParkingProvider, bool>(
      selector: (_, p) => p.buttonClicked,
      builder: (context, bool isSelected,___) {
        return MainButton(
          backgroundColor: isSelected ? Colors.white: Colors.blue,
          borderColor:  isSelected ? Colors.blue: Colors.transparent,
          textColor: isSelected ? Colors.black: Colors.white,
              width: 150,
              height: 35,
          onPressed: () => provider.ontap(historicProvider),
          label: 'Parking',
        );
      }
    );
  }
}
