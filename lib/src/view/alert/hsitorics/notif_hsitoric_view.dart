import 'package:flutter/material.dart';
import 'package:newgps/src/models/notif_historic_model.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';

import 'notif_historic_provider.dart';

class NotifHistoricView extends StatelessWidget {
  const NotifHistoricView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifHistoricPorvider>(
        create: (_) => NotifHistoricPorvider(),
        builder: (BuildContext context, __) {
          NotifHistoricPorvider porvider =
              Provider.of<NotifHistoricPorvider>(context, listen: false);
          porvider.initDevices(context);
          return Scaffold(
            appBar:
                const CustomAppBar(actions: [CloseButton(color: Colors.black)]),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(),
                const SizedBox(height: 20),
                Container(height: 0.6, color: Colors.grey),
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    right: false,
                    child: Selector<NotifHistoricPorvider, List<NotifHistoric>>(
                        selector: (_, __) => __.histos,
                        builder: (_, histos, __) {
                          if (histos.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.hourglass_empty_rounded,
                                    size: 66,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pas historiques pour le moment',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: histos.length,
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 150),
                            itemBuilder: (_, int index) {
                              return _HistoricCard(
                                notifHistoric: histos.elementAt(index),
                              );
                            },
                            separatorBuilder: (_, __) => Container(
                              height: 0.6,
                              color: Colors.grey,
                              margin: const EdgeInsets.fromLTRB(74, 08, 0, 08),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildLabel() {
    return SafeArea(
      bottom: false,
      top: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: const [
            SizedBox(height: 10),
            Text(
              'Historiques',
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricCard extends StatelessWidget {
  final NotifHistoric notifHistoric;
  const _HistoricCard({Key? key, required this.notifHistoric})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotifHistoricPorvider provider =
        Provider.of<NotifHistoricPorvider>(context, listen: false);
    return GestureDetector(
      onTap: () => provider.navigateToDetaisl(context, model: notifHistoric),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppConsts.mainColor, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      IconData(notifHistoric.hexIcon,
                          fontFamily: notifHistoric.type),
                      color: AppConsts.mainColor,
                      size: 19),
                  const SizedBox(height: 6),
                  Text(provider.getLabel(notifHistoric.type)),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifHistoric.device,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifHistoric.message,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    whatsapFormatOnlyTime(
                        notifHistoric.createdAt.add(const Duration(hours: 1))),
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (notifHistoric.countNotRead > 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Text(
                        '${notifHistoric.countNotRead}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
