import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/device.dart';
import '../../services/device_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/buttons/appele_condcuteur_button.dart';
import '../../widgets/buttons/zoom_button.dart';
import '../../widgets/date_hour_widget.dart';
import '../../widgets/map_type_widget.dart';
import '../auto_search/auto_search.dart';
import '../last_position/card_info.dart';
import '../navigation/top_app_bar.dart';
import 'historic_provider.dart';
import 'histroric_map_view.dart';
import 'parking/parking_provider.dart';
import 'play_card.dart';

class HistoricViews extends StatefulWidget {
  const HistoricViews({super.key});

  @override
  State<HistoricViews> createState() => _HistoricViewsState();
}

class _HistoricViewsState extends State<HistoricViews> {
  Key newMapKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    HistoricProvider provider =
        Provider.of<HistoricProvider>(context, listen: false);
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    provider.init(context);
    provider.initTimeRange();
    return ChangeNotifierProvider<ParkingProvider>(
        create: (_) => ParkingProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: CustomAppBar(
              onTap: deviceProvider.handleSelectDevice,
              actions: [
                InkWell(
                  onTap: provider.playHistoric,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Consumer<HistoricProvider>(
                      builder: (_, provider, __) {
                        if (provider.loading) {
                          return const Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConsts.mainColor),
                                ),
                              ),
                            ),
                          );
                        }
                        return Icon(
                          provider.historicIsPlayed
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline_outlined,
                          color: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
                //RotateIconMap(normalview: provider.normaleView),
                MapTypeWidget(onChange: (mapType) {
                  deviceProvider.mapType = mapType;
                }),
              ],
            ),
            body: Stack(
              children: [
                HistoricMapView(
                  newMapKey: newMapKey,
                ),
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
                          provider.animateMarker.clear();
                          provider.markers.clear();
                          newMapKey = UniqueKey();
                          setState(() {});
                          await provider.fetchHistorics(context, device);
                        },
                      );
                    }),

                AppelCondicteurButton(
                  device: deviceProvider.selectedDevice,
                  callNewData: () async {
                    await deviceProvider.fetchDevice();
                  },
                  showParkingButton: true,
                ),
                //const ShowAllMarkersButton(),
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
                            DateHourWidget(
                              dateTo: provider.dateTo,
                              dateFrom: provider.dateFrom,
                            ),
                            const SizedBox(height: 7),
                            MapZoomWidget(
                              controller: provider.googleMapController,
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
                  },
                ),
              ],
            ),
          );
        });
  }
}
