import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';

class AlertView extends StatelessWidget {
  const AlertView({Key? key}) : super(key: key);

  final List<_AlertItem> _items = const [
    _AlertItem(
      icon: Icons.speed,
      label: 'Vitesse',
      page: '/speed',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.ev_station_rounded,
      label: 'Carburant',
      page: '/fuel',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.battery_charging_full,
      label: 'Batterie',
      page: '/battery',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.radar,
      label: 'Capot',
      page: '/capot',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.edit_road_rounded,
      label: 'Température',
      page: '/temp',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.stacked_line_chart_sharp,
      label: 'Kilometrage',
      page: '/odometre',
    ),
    _AlertItem(
      icon: Icons.car_repair_sharp,
      label: 'Depanage',
      page: '/depanage',
    ),
    _AlertItem(
      icon: Icons.health_and_safety_sharp,
      label: 'Débranchement',
      page: '/debranchement',
    ),
    _AlertItem(
      icon: Icons.flash_off_outlined,
      label: 'Autoroute',
      page: '/highway',
    ),
    _AlertItem(
      icon: Icons.dangerous,
      label: 'Demarage',
      page: '/demarage',
    ),
    _AlertItem(
      icon: Icons.car_rental,
      label: 'Vidange',
      page: '/vidange',
    ),
    _AlertItem(
      icon: Icons.table_chart_rounded,
      label: 'Visite technique',
      page: '/visite',
    ),
    _AlertItem(
      icon: Icons.verified_user_rounded,
      label: 'Immobilisation',
      page: '/immobilisation',
    )
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        width: size.width,
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: _items.length,
                padding: const EdgeInsets.all(AppConsts.outsidePadding),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  crossAxisSpacing: AppConsts.outsidePadding,
                  mainAxisSpacing: AppConsts.outsidePadding,
                ),
                itemBuilder: (_, int index) {
                  return _AlertCatd(alertItem: _items.elementAt(index));
                },
              ),
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
