import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigatioBar extends StatefulWidget {
  final PageController pageController;

  const CustomBottomNavigatioBar({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CustomBottomNavigatioBar> createState() =>
      _CustomBottomNavigatioBarState();
}

class _CustomBottomNavigatioBarState extends State<CustomBottomNavigatioBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Account? _account;
  @override
  void initState() {
    super.initState();
    _account = shared.getAccount();
    _initItems();
    _tabController = TabController(
      length: _items.length,
      vsync: this,
    );
  }

  late List<_BuildTabBarItem> _items;

  void _initItems() {
    _items = [
      const _BuildTabBarItem(icon: 'last_position', label: 'Position'),
      const _BuildTabBarItem(icon: 'historic', label: 'Historique'),
      const _BuildTabBarItem(icon: 'report', label: 'Rapport'),
      const _BuildTabBarItem(icon: 'alert', label: 'Alerte'),
      const _BuildTabBarItem(icon: 'geozone', label: 'Géozone'),
      if (_account?.account.userID == null)
        const _BuildTabBarItem(icon: 'user', label: 'Utilisateur'),
      const _BuildTabBarItem(icon: 'matricule', label: 'Matricule'),
      const _BuildTabBarItem(icon: 'cam', label: 'Caméra'),
      const _BuildTabBarItem(icon: 'gestion', label: 'Gestion'),
      const _BuildTabBarItem(icon: 'driver', label: 'Conduite'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      onTap: (int index) {
        DeviceProvider deviceProvider =
            Provider.of<DeviceProvider>(context, listen: false);
        deviceProvider.selectedTabIndex = index;
        widget.pageController.jumpToPage(index);
        playAudio(_items.elementAt(index).label);
      },
      labelColor: Colors.black,
      tabs: _items,
      indicator: const BoxDecoration(
          border: Border(
              top: BorderSide(
        width: 4.0,
        color: AppConsts.mainColor,
      ))),
    );
  }
}

class _BuildTabBarItem extends StatelessWidget {
  final String label;
  final String icon;

  const _BuildTabBarItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Image.network(
          'https://api.newgps.ma/api/icons/$icon.svg',
          width: 17,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
