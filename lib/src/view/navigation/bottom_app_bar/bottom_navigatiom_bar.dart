import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/utils/utils.dart';
import 'package:newgps/src/widgets/badge_icon.dart';

class CustomBottomNavigatioBar extends StatefulWidget {
  final PageController pageController;
  final bool alert;
  const CustomBottomNavigatioBar(
      {Key? key, required this.pageController, this.alert = false})
      : super(key: key);

  @override
  State<CustomBottomNavigatioBar> createState() =>
      _CustomBottomNavigatioBarState();
}

class _CustomBottomNavigatioBarState extends State<CustomBottomNavigatioBar> {
  final List<BottomAppBarItem> _items = [
    BottomAppBarItem(icon: 'last_position', label: 'Position', index: 0),
    BottomAppBarItem(icon: 'historic', label: 'Historique', index: 1),
    BottomAppBarItem(icon: 'report', label: 'Rapport', index: 2),
    BottomAppBarItem(icon: 'alert', label: 'Alerte', index: 3),
    BottomAppBarItem(icon: 'geozone', label: 'Géozone', index: 4),
    BottomAppBarItem(icon: 'user', label: 'Utilisateur', index: 5),
    BottomAppBarItem(icon: 'matricule', label: 'Matricule', index: 6),
    BottomAppBarItem(icon: 'cam', label: 'Caméra', index: 7),
    BottomAppBarItem(icon: 'gestion', label: 'Gestion', index: 8),
    BottomAppBarItem(icon: 'driver', label: 'Conduite', index: 9),
  ];

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_pageControllerListner);

    if (widget.alert) {
      _selectedIndex = 3;
    }
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
  void didUpdateWidget(covariant CustomBottomNavigatioBar oldWidget) {
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
                childAspectRatio: 4.0,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
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
        border: Border.all(color: AppConsts.mainColor, width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.network('${Utils.baseUrl}/icons/${item.icon}.svg',
                height: 12),
            Text(
              item.label,
              maxLines: 1,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
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
              SvgPicture.network(
                '${Utils.baseUrl}/icons/${item.icon}.svg',
                height: 12,
              ),
              Text(
                item.label,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
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
