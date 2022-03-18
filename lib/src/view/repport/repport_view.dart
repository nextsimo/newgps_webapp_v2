import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/view/repport/details/repport_detials.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/date_time_picker/date_map_picker.dart';
import 'package:newgps/src/widgets/date_time_picker/time_range_widget.dart';
import 'package:provider/provider.dart';
import 'auto_search_repport_type.dart';
import 'connexion/connxion_view.dart';
import 'distance/view/distance_view.dart';
import 'fuel/fuel_repport_view.dart';
import 'repport_auto_search.dart';
import 'resume/loading/linear_lodaing_button.dart';
import 'resume/resume_repport.dart';
import 'trips/trips_view.dart';

class RepportView extends StatelessWidget {
  const RepportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    return ChangeNotifierProvider<RepportProvider>(
      create: (_) => RepportProvider(deviceProvider.devices),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: const RepportDataView(),
    );
  }
}

class RepportDataView extends StatelessWidget {
  const RepportDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepportProvider repportProvider = Provider.of<RepportProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(actions: []),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  const AutoSearchField(),
                  const AutoSearchType(),
                  if (repportProvider.selectedRepport.index != 0)
                    DateTimePicker(
                      width: 310,
                      dateFrom: repportProvider.dateFrom,
                      dateTo: repportProvider.dateTo,
                      onTapDateFrom: () =>
                          repportProvider.updateDateFrom(context),
                      onTapDateTo: () => repportProvider.updateDateTo(context),
                      onTapTime: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: TimeRangeWigdet(
                              provider: repportProvider,
                              onRestaure: () =>
                                  repportProvider.restaureTime(context),
                              onSave: () => repportProvider.updateTime(context),
                            ),
                          ),
                        );
                      },
                    ),
                  if (repportProvider.selectedRepport.index != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: MainButton(
                        width: 140,
                        icon: Icons.call,
                        height: 32,
                        onPressed: () {
                          locator<DriverPhoneProvider>().checkPhoneDriver(
                              context: context,
                              device: repportProvider.selectedDevice,
                              callNewData: () async {
                                deviceProvider.selectedDevice =
                                    repportProvider.selectedDevice;
                                await deviceProvider.fetchDevice();
                                repportProvider.selectedDevice =
                                    deviceProvider.selectedDevice;
                              });
                        },
                        label: 'Conducteur',
                      ),
                    ),
                  const SizedBox(width: 6),
                  MainButton(
                    onPressed: () => repportProvider.downloadDocument(context),
                    label: 'Télécharger',
                    height: 35,
                    width: 120,
                  ),
                  if (repportProvider.selectedRepport.index == 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Selector<RepportProvider, bool>(
                        builder: (_, bool isFetching, __) {
                          String message = isFetching ? 'Arrêter' : 'Démarrer';
                          return Column(
                            children: [
                              MainButton(
                                width: 190,
                                height: 35,
                                borderColor:
                                    isFetching ? Colors.red : Colors.green,
                                textColor:
                                    isFetching ? Colors.white : Colors.green,
                                backgroundColor:
                                    isFetching ? Colors.red : Colors.white,
                                onPressed: () => repportProvider.isFetching =
                                    !repportProvider.isFetching,
                                label: "$message l'actualisation",
                              ),
                              if (isFetching) const LinearLoadingButton(),
                            ],
                          );
                        },
                        selector: (_, p) => p.isFetching,
                      ),
                    ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: AppConsts.outsidePadding),
                child: LogoutButton(
                  witdh: 116,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConsts.outsidePadding),
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, __) {
                  switch (repportProvider.selectedRepport.index) {
                    case 0:
                      return const ResumeRepport();
                    case 1:
                      return const RepportDetailsView();
                    case 2:
                      return const FuelRepportView();
                    case 3:
                      return const TripsView();
                    case 4:
                      return const DistanceView();
                    case 5:
                      return const ConnexionRepportView();
                    default:
                      return const Material();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
