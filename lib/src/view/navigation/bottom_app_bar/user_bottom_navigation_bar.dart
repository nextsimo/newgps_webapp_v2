import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:newgps/src/widgets/badge_icon.dart';
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
    extends State<UserCustomBottomNavigatioBar> {
  late List<BottomAppBarItem> _items;

  void _initItems() {
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    _items = [
      if (pro.userDroits.droits[1].read)
        BottomAppBarItem(icon: 'last_position', label: 'Position'),
      if (pro.userDroits.droits[2].read)
        BottomAppBarItem(icon: 'historic', label: 'Historique'),
      if (pro.userDroits.droits[3].read)
        BottomAppBarItem(icon: 'report', label: 'Rapport'),
      if (pro.userDroits.droits[4].read)
        BottomAppBarItem(icon: 'alert', label: 'Alerte'),
      if (pro.userDroits.droits[5].read)
        BottomAppBarItem(icon: 'geozone', label: 'Géozone'),
      if (pro.userDroits.droits[7].read)
        BottomAppBarItem(icon: 'matricule', label: 'Matricule'),
      if (pro.userDroits.droits[8].read)
        BottomAppBarItem(icon: 'cam', label: 'Caméra'),
      if (pro.userDroits.droits[9].read)
        BottomAppBarItem(icon: 'gestion', label: 'Gestion'),
      if (pro.userDroits.droits[10].read)
        BottomAppBarItem(icon: 'driver', label: 'Conduite'),
    ];

    int _index = -1;
    for (var element in _items) {
      _index++;

      element.index = _index;
    }
  }

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_pageControllerListner);
    _initItems();
  }

  void _pageControllerListner() {
    _selectedIndex = widget.pageController.page!.toInt();
    setState(() {});
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageControllerListner);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UserCustomBottomNavigatioBar oldWidget) {
    // ignore: invalid_use_of_protected_member
    if (!widget.pageController.hasListeners) {
      widget.pageController.addListener(_pageControllerListner);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, or) {
      Size size = MediaQuery.of(context).size;
      return Container(
        color: Colors.white,
        child: SafeArea(
          left: false,
          right: false,
          child: Container(
            width: size.width,
            color: Colors.white,
            child: GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 8,
                childAspectRatio: 3.0,
              ),
              children: _items.map((item) {
                return InkWell(
                  onTap: () {
                    widget.pageController.jumpToPage(item.index);
                    playAudio(_items.elementAt(item.index).label);
                  },
                  child: _BuildTabBarItem(
                    isSelected: item.index == _selectedIndex,
                    item: item,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

class _BuildTabBarItem extends StatelessWidget {
  final BottomAppBarItem item;
  final bool isSelected;

  const _BuildTabBarItem({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (item.icon == 'alert') {
      return _AlertTabBarItem(
        isSelected: isSelected,
        item: item,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? AppConsts.mainColor.withOpacity(0.2)
            : Colors.transparent,
        border: Border.all(color: AppConsts.mainColor, width: 2.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://api.newgps.ma/api/icons/${item.icon}.svg',
              height: 16,
            ),
            Text(
              item.label,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomAppBarItem {
  int index;
  final String icon;
  final String label;

  BottomAppBarItem({required this.icon, required this.label, this.index = 0});
}

class _AlertTabBarItem extends StatelessWidget {
  final BottomAppBarItem item;
  final bool isSelected;
  const _AlertTabBarItem(
      {Key? key, required this.item, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? AppConsts.mainColor.withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(color: AppConsts.mainColor, width: 2.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://api.newgps.ma/api/icons/${item.icon}.svg',
                height: 16,
              ),
              const SizedBox(height: 5),
              Text(
                item.label,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const Positioned(
          top: -5.2,
          right: -3,
          child: BadgeIcon(),
        ),
      ],
    );
  }
}
