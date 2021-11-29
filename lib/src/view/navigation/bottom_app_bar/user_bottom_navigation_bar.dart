import 'package:flutter/material.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class UserCustomBottomNavigatioBar extends StatefulWidget {
  final PageController pageController;

  const UserCustomBottomNavigatioBar({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<UserCustomBottomNavigatioBar> createState() =>
      _UserCustomBottomNavigatioBarState();
}

class _UserCustomBottomNavigatioBarState
    extends State<UserCustomBottomNavigatioBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _initItems();
    _tabController = TabController(
      length: _items.length,
      vsync: this,
    );
  }

  late List<_BuildTabBarItem> _items;

  void _initItems() {
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    _items = [
      if (pro.userDroits.droits[0].read)
        const _BuildTabBarItem(icon: 'last_position', label: 'Position'),
      if (pro.userDroits.droits[1].read)
        const _BuildTabBarItem(icon: 'historic', label: 'Historique'),
      if (pro.userDroits.droits[2].read)
        const _BuildTabBarItem(icon: 'report', label: 'Rapport'),
      if (pro.userDroits.droits[3].read)
        const _BuildTabBarItem(icon: 'alert', label: 'Alerte'),
      if (pro.userDroits.droits[4].read)
        const _BuildTabBarItem(icon: 'geozone', label: 'Géozone'),
      if (pro.userDroits.droits[5].read)
        const _BuildTabBarItem(icon: 'matricule', label: 'Matricule'),
      if (pro.userDroits.droits[6].read)
        const _BuildTabBarItem(icon: 'cam', label: 'Caméra'),
      if (pro.userDroits.droits[7].read)
        const _BuildTabBarItem(icon: 'gestion', label: 'Gestion'),
      if (pro.userDroits.droits[8].read)
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
