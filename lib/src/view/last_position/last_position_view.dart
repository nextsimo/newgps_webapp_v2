import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/auto_search/auto_search_with_all.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/last_position/lastposition_map_view.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/zoom_button.dart';
import 'package:newgps/src/widgets/map_type_widget.dart';
import 'package:provider/provider.dart';
import 'card_info.dart';
import 'date_widget.dart';
import 'grouped_buttons.dart';
import 'suivi/suivi_widget.dart';

class LastPositionView extends StatelessWidget {
  const LastPositionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);
    lastPositionProvider.fetchInitDevice();
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        onTap: lastPositionProvider.handleSelectDevice,
        actions: [
          IconButton(
            onPressed: lastPositionProvider.normaleView,
            icon: Transform.rotate(
              angle: 45,
              child: const Icon(
                Icons.navigation_outlined,
                color: Colors.black,
              ),
            ),
          ),
          MapTypeWidget(onChange: (mapType) {
            deviceProvider.mapType = mapType;
            lastPositionProvider.notifyTheMap();
          }),
        ],
      ),
      body: Stack(
        children: [
          const LastpositionMap(),
          const AutoSearchDeviceWithAll(
          ),
          const CardInfoView(),
          const Positioned(
            top: AppConsts.outsidePadding,
            right: AppConsts.outsidePadding,
            child: LogoutButton(),
          ),
          const DateWidget(),
          Positioned(
            top: 50,
            left: AppConsts.outsidePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SuiviWidget(),
                const SizedBox(height: 6),
                MapZoomWidget(completer: lastPositionProvider.controller),
              ],
            ),
          ),
          const GroupedButton(),
        ],
      ),
    );
  }
}
