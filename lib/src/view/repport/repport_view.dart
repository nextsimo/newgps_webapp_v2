import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/view/repport/details/repport_detials.dart';
import 'package:newgps/src/view/repport/rapport_provider.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/date_time_picker/date_map_picker.dart';
import 'package:newgps/src/widgets/date_time_picker/date_month_picker.dart';
import 'package:newgps/src/widgets/date_time_picker/time_range_widget.dart';
import 'package:provider/provider.dart';
import 'auto_search_repport_type.dart';
import 'fuel/fuel_repport_view.dart';
import 'repport_auto_search.dart';
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
                  if (repportProvider.selectedRepport.index == 2)
                    const DateMonthPicker(),
                  if (repportProvider.selectedRepport.index != 2)
                    DateTimePicker(
                      width: 300,
                      dateFrom: repportProvider.dateFrom,
                      dateTo: repportProvider.dateTo,
                      onTapDate: () => repportProvider.updateDate(context),
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
                      padding: const EdgeInsets.only(left: 10),
                      child: MainButton(
                        width: 150,
                        height: 32,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  child: Container(
                                    width: 300,
                                    padding: const EdgeInsets.all(17),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MainButton(
                                          onPressed: () {},
                                          icon: Icons.phone_forwarded_rounded,
                                          label: repportProvider
                                              .selectedDevice.phone1,
                                        ),
                                        const SizedBox(height: 10),
                                        if (repportProvider
                                            .selectedDevice.phone2.isNotEmpty)
                                          MainButton(
                                            onPressed: () {},
                                            icon: Icons.phone_forwarded_rounded,
                                            label: repportProvider
                                                .selectedDevice.phone2,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        label: 'Appel conducteur',
                      ),
                    ),
                  const SizedBox(width: 6),
                  MainButton(
                    onPressed: () => repportProvider.downloadDocument(context),
                    label: 'Télécharger',
                    height: 35,
                    width: 120,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: AppConsts.outsidePadding),
                child: LogoutButton(),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConsts.outsidePadding),
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
