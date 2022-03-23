/* import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import '../last_position_provider.dart';

class SuiviWidget extends StatelessWidget {
  const SuiviWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context);
    if (!lastPositionProvider.fetchAll) {
      bool isEmpty = lastPositionProvider.polylines.isEmpty;
      return Row(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(15)),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => isEmpty ? AppConsts.blue : Colors.white),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConsts.mainradius))),
            ),
            onPressed: () => lastPositionProvider.buildRoutes(),
            child: Row(
              children: [
                lastPositionProvider.loadingRoute
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white))),
                      )
                    : Image.asset(
                        'assets/icons/map_arrow.png',
                        width: 18,
                        color: isEmpty ? Colors.white : Colors.blue,
                      ),
                const SizedBox(width: 6),
                Text(
                  'Itinéraire',
                  style: GoogleFonts.amiri(
                    color: isEmpty ? Colors.white : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
 */