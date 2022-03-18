import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/auto_search/auto_search.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/historic/histroric_map_view.dart';
import 'package:newgps/src/view/historic/play_card.dart';
import 'package:newgps/src/view/last_position/card_info.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/appele_condcuteur_button.dart';
import 'package:newgps/src/widgets/buttons/zoom_button.dart';
import 'package:newgps/src/widgets/date_hour_widget.dart';
import 'package:newgps/src/widgets/map_type_widget.dart';
import 'package:provider/provider.dart';

class HistoricView extends StatelessWidget {
  const HistoricView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    provider.init(context);
    provider.initTimeRange();
    return Scaffold(
      appBar: CustomAppBar(
        onTap: deviceProvider.handleSelectDevice,
        actions: [
          const SizedBox(width: 5),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.loading,
              builder: (_, bool loading, ___) {
                if (loading) {
                  return const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppConsts.mainColor),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
          const SizedBox(width: 5),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                return IconButton(
                  onPressed: provider.playHistoric,
                  icon: Icon(isPlayed
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_outlined),
                  color: Colors.black,
                );
              }),
          IconButton(
            onPressed: provider.normaleView,
            icon: Transform.rotate(
              angle: 45,
              child: const Icon(
                Icons.navigation_outlined,
                color: Colors.black,
              ),
            ),
          ),
          MapTypeWidget(
            onChange: (mapType) {
              deviceProvider.mapType = mapType;
              provider.notify();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const HistoricMapView(),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (!isPlayed) return const SizedBox();
                return const PlayCard();
              }),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return AutoSearchDevice(
                  onSelectDeviceFromOtherView: (Device device) async {
                    provider.fetchHistorics(device.deviceId ,1, true);
                  },
                );
              }),
          AppelCondicteurButton(
            device: deviceProvider.selectedDevice,
            callNewData: () async {
              await deviceProvider.fetchDevice();
            },
          ),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return Positioned(
                  left: AppConsts.outsidePadding,
                  top: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DateHourWidget(),
                      const SizedBox(height: 7),
                      MapZoomWidget(
                        completer: provider.controller,
                      ),
                    ],
                  ),
                );
              }),
          Selector<HistoricProvider, bool>(
              selector: (_, p) => p.historicIsPlayed,
              builder: (_, bool isPlayed, ___) {
                if (isPlayed) return const SizedBox();
                return const CardInfoView();
              }),
        ],
      ),
    );
  }
}
