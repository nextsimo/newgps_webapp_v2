import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:newgps/src/utils/functions.dart';

import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import '../../../models/notif_historic_model.dart';
import '../../navigation/top_app_bar.dart';
import 'notif_historic_provider.dart';
import 'notif_hsitoric_view.dart';
import 'widgets/historic_widget.dart';

class NotifHistorisDetails extends StatelessWidget {
  final String type;
  const NotifHistorisDetails({Key? key, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifHistoricPorvider>(
        create: (_) => NotifHistoricPorvider(type: type),
        builder: (BuildContext context, ___) {
          NotifHistoricPorvider porvider =
              Provider.of<NotifHistoricPorvider>(context, listen: false);
          porvider.initDevices(context);
          return Scaffold(
            appBar: CustomAppBar(
              actions: [
                CloseButton(
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const NotifHistoricView())),
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHead(context, type),
                Consumer<NotifHistoricPorvider>(
                  builder: (_, pro, __) {
                    if (pro.histos.isEmpty) return const SizedBox();
                    return Expanded(
                      child: SafeArea(
                        bottom: false,
                        right: false,
                        top: false,
                        child: GroupedListView<NotifHistoric, DateTime>(
                          controller: pro.scrollController,
                          useStickyGroupSeparators:
                              pro.histos.length > 9 ? true : false,
                          order: GroupedListOrder.DESC,
                          elements: porvider.histos,
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 150),
                          groupBy: (_) => DateTime(_.createdAt.year,
                              _.createdAt.month, _.createdAt.day),
                          itemComparator: (notif1, notif2) => DateTime(
                                  notif1.createdAt.year,
                                  notif1.createdAt.month,
                                  notif1.createdAt.day)
                              .compareTo(DateTime(
                                  notif2.createdAt.year,
                                  notif2.createdAt.month,
                                  notif2.createdAt.day)),
                          groupComparator: (d1, d2) => DateTime(
                                  d1.year, d1.month, d1.day)
                              .compareTo(DateTime(d2.year, d2.month, d2.day)),
                          itemBuilder: (_, NotifHistoric notifHistoric) =>
                              _HistoricCard(notifHistoric: notifHistoric),
                          floatingHeader: true,
                          reverse: true,
                          sort: false,
                          groupSeparatorBuilder: (DateTime groupByValue) =>
                              GroupSeparatorBuilderWidget(
                            groupByValue: groupByValue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Container _buildHead(BuildContext context, String type) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black45, offset: Offset(0, 0), blurRadius: 3),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, type),
          const SizedBox(height: 7),
          const BuildSearchHistoric(),
          const SizedBox(height: 3),
          Container(height: 0.6, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String type) {
    NotifHistoricPorvider porvider =
        Provider.of<NotifHistoricPorvider>(context, listen: false);
    return SafeArea(
      bottom: false,
      top: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            const SizedBox(height: 13),
            Text(
              'Historiques ${porvider.getLabel(type)}',
              style:  GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupSeparatorBuilderWidget extends StatelessWidget {
  final DateTime groupByValue;
  const GroupSeparatorBuilderWidget({
    Key? key,
    required this.groupByValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          constraints: const BoxConstraints(maxWidth: 100),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 8), blurRadius: 12)
              ]),
          child: Text(
            whatsapFormat(groupByValue),
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
class _HistoricCard extends StatelessWidget {
  final NotifHistoric notifHistoric;
  const _HistoricCard({Key? key, required this.notifHistoric})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotifHistoricPorvider porvider = Provider.of<NotifHistoricPorvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notifHistoric.device,
                      style:  GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainButton(
                          onPressed: () => porvider.call(context, notifHistoric.deviceId),
                          label: 'Conducteur',
                          width: 150,
                          height: 30,
                          icon: Icons.call,
                        ),
                        const SizedBox(width: 3),
                        MainButton(
                          onPressed: () => porvider.findAlertPosition(context: context, deviceId: notifHistoric.deviceId, timestamp: notifHistoric.timestamp),
                          label: 'Localiser',
                          width: 150,
                          height: 30,
                          icon: Icons.location_on,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              constraints: const BoxConstraints(minWidth: 70),
              decoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    notifHistoric.message,
                    style:  GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            if( notifHistoric.address.isEmpty )
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  whatsapFormatOnlyTime(
                      notifHistoric.createdAt.add(const Duration(hours: 1))),
                  style: GoogleFonts.roboto(
                    color: Colors.grey[700],
                  ),
                ),
              ),
          ],
        ),
        if (notifHistoric.address.isNotEmpty) const SizedBox(height: 4),
        const SizedBox(width: 10),
        if (notifHistoric.address.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (notifHistoric.address.isEmpty) const SizedBox(),
              if (notifHistoric.address.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      notifHistoric.address,
                      style:  GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  whatsapFormatOnlyTime(
                      notifHistoric.createdAt.add(const Duration(hours: 1))),
                  style: GoogleFonts.roboto(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 7, 0, 7),
          height: 0.6,
          color: Colors.grey,
        ),
      ],
    );
  }
}
