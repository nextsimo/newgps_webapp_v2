import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/badge_icon.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class AlertView extends StatelessWidget {
  const AlertView({Key? key}) : super(key: key);

  final List<_AlertItem> _items = const [
    _AlertItem(
        icon: IconData(0xe800, fontFamily: 'speed'),
        label: 'Vitesse',
        page: '/speed',
        inDev: false),
    _AlertItem(
        icon: Icons.ev_station_rounded,
        label: 'Carburant',
        page: '/fuel',
        inDev: false),
    _AlertItem(
        icon: Icons.battery_charging_full,
        label: 'Batterie',
        page: '/battery',
        inDev: false),
    _AlertItem(icon: Icons.radar, label: 'Capot', page: '/capot', inDev: false),
    _AlertItem(
        icon: Icons.radio_button_on_sharp,
        label: 'Radar',
        page: '/radar',
        inDev: false),
    _AlertItem(
        icon: Icons.fireplace,
        label: 'Température',
        page: '/temp',
        inDev: false),
    _AlertItem(
        icon: Icons.stacked_line_chart_sharp,
        label: 'Kilometrage',
        page: '/odometre',
        inDev: false),
    _AlertItem(
        icon: Icons.flash_off_outlined,
        label: 'Débranchement',
        page: '/debranchement',
        inDev: false),
    _AlertItem(
        icon: Icons.edit_road_rounded,
        label: 'Autoroute',
        page: '/highway',
        inDev: false),
    _AlertItem(
        icon: Icons.car_repair_sharp, label: 'Depanage', page: '/depanage'),
    _AlertItem(icon: Icons.dangerous, label: 'Demarage', page: '/demarage'),
    _AlertItem(
        icon: Icons.verified_user_rounded,
        label: 'Immobilisation',
        page: '/immobilisation'),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SizedBox(
        width: size.width,
        child: Stack(
          children: [
            GridView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.fromLTRB(
                  AppConsts.outsidePadding, 47, AppConsts.outsidePadding, 60),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                crossAxisSpacing: AppConsts.outsidePadding,
                mainAxisSpacing: AppConsts.outsidePadding,
              ),
              itemBuilder: (_, int index) {
                return _AlertCatd(alertItem: _items.elementAt(index));
              },
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppConsts.outsidePadding, top: 8),
                  child: MainButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/historics'),
                    label: 'Historiques',
                    width: 150,
                    height: 30,
                    backgroundColor: Colors.orange,
                  ),
                ),
                const Positioned(
                  right: -5,
                  top: 0,
                  child: BadgeIcon(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem {
  final String label;
  final String page;
  final IconData icon;
  final bool inDev;

  const _AlertItem(
      {required this.label,
      required this.page,
      required this.icon,
      this.inDev = true});
}

class _AlertCatd extends StatelessWidget {
  final _AlertItem alertItem;
  const _AlertCatd({Key? key, required this.alertItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!alertItem.inDev) {
          Navigator.of(context).pushNamed(alertItem.page);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 10),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Icon(alertItem.icon, color: AppConsts.mainColor),
            const SizedBox(height: 10),
            Text(alertItem.label),
            const SizedBox(height: 12),
            if (alertItem.inDev)
              const Text('En cours...', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
