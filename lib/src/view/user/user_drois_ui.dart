import 'package:flutter/material.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/utils/styles.dart';

class UserDroitsUi extends StatefulWidget {
  final UserDroits userDroits;
  const UserDroitsUi({Key? key, required this.userDroits}) : super(key: key);

  @override
  State<UserDroitsUi> createState() => _UserDroitsUiState();
}

class _UserDroitsUiState extends State<UserDroitsUi> {
  final GlobalKey _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  late Size? buttonSize;
  late Offset buttonPosition;
  bool isMenuOpen = false;

  void findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry?.remove();
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy,
          left: buttonPosition.dx,
          width: buttonSize!.width,
          child: _ShowListDrois(
            closeMenu: closeMenu,
            userDroits: widget.userDroits,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (isMenuOpen) closeMenu();
    _overlayEntry!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (isMenuOpen) {
              closeMenu();
            } else {
              openMenu();
            }
          },
          child: Container(
            key: _key,
            width: 360,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: AppConsts.mainColor, width: AppConsts.borderWidth),
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
            ),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      'Modifier les droits',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey)
              ],
            ),
          ),
        ),

/*         const SizedBox(width: 10),
        Text(
          '${widget.user.devices.length} Selectioné',
          textAlign: TextAlign.center,
        ), */
      ],
    );
  }
}

class _ShowListDrois extends StatefulWidget {
  final UserDroits userDroits;
  final Function closeMenu;
  const _ShowListDrois(
      {Key? key, required this.closeMenu, required this.userDroits})
      : super(key: key);

  @override
  State<_ShowListDrois> createState() => _ShowListDroisState();
}

class _ShowListDroisState extends State<_ShowListDrois> {
  final List<String> _listStr = const [
    'Tous les droits',
    'Position',
    'Historique',
    'Rapport',
    'Alerte',
    'Géozone',
    'Utilisateur',
    'Matricule',
    'Caméra',
    'Gestion',
    'Conduite'
  ];

  @override
  void initState() {
    super.initState();

    // read : false : true,
    // write : false : true,
    // index 0
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppConsts.mainColor, width: 1.5),
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CloseButton(
              color: Colors.black,
              onPressed: () {
                widget.closeMenu();
              },
            ),
            _devicesList(context),
          ],
        ),
      ),
    );
  }

  Widget _devicesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        String str = _listStr.elementAt(index);
        Droit userDrois = widget.userDroits.droits.elementAt(index);
        return CheckedDroits(
          color: userDrois.index == 10 ? Colors.red : null,
            onTapRead: (int _index) {
              if (_index == 10) {
                widget.userDroits.droits.first.read =
                    !widget.userDroits.droits.first.read;
                for (var d in widget.userDroits.droits) {
                  d.read = widget.userDroits.droits.first.read;
                }
                if (widget.userDroits.droits.first.write &&
                    !widget.userDroits.droits.first.read) {
                  widget.userDroits.droits.first.write = false;
                  for (var d in widget.userDroits.droits) {
                    d.write = false;
                  }
                }

                setState(() {});
              } else {
                widget.userDroits.droits.first.read = false;
                widget.userDroits.droits[index].read =
                    !widget.userDroits.droits[index].read;

                if (widget.userDroits.droits[index].write &&
                    !widget.userDroits.droits[index].read) {
                  widget.userDroits.droits[index].write = false;
                }
                setState(() {});
              }
            },
          element: str,
          userDroits: widget.userDroits,
          droit: userDrois,
            onTapWrite: (int _index) {
              if (_index == 10) {
                widget.userDroits.droits.first.write =
                    !widget.userDroits.droits.first.write;
                for (var d in widget.userDroits.droits) {
                  d.write = widget.userDroits.droits.first.write;
                }
                if (widget.userDroits.droits.first.write &&
                    !widget.userDroits.droits.first.read) {
                  widget.userDroits.droits.first.read = true;
                  for (var d in widget.userDroits.droits) {
                    d.read = true;
                  }
                }
                setState(() {});
              } else {
                widget.userDroits.droits.first.write = false;
                widget.userDroits.droits[index].write =
                    !widget.userDroits.droits[index].write;
                if (widget.userDroits.droits[index].write &&
                    !widget.userDroits.droits[index].read) {
                  widget.userDroits.droits[index].read =
                      !widget.userDroits.droits[index].read;
                }
                setState(() {});
              }
            },
        );
      },
      separatorBuilder: (_, int index) => index == 0
          ? Container(
              height: 1.3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey,
            )
          : const SizedBox(height: 10),
      itemCount: _listStr.length,
    );
  }
}

class CheckedDroits extends StatefulWidget {
  final void Function(int index) onTapRead;
  final void Function(int index) onTapWrite;
  final String element;
  final UserDroits userDroits;
  final Color? color;
  final Droit droit;
  const CheckedDroits(
      {Key? key,
      required this.element,
      required this.userDroits,
      required this.droit,
      required this.onTapRead,
      required this.onTapWrite,
      required this.color})
      : super(key: key);

  @override
  State<CheckedDroits> createState() => _CheckedDroitsState();
}

class _CheckedDroitsState extends State<CheckedDroits> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              '${widget.element}:',
              style: TextStyle(color: widget.color),
            ),
            const SizedBox(width: 10),
          ],
        )),
        Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lire',
                  style: TextStyle(color: Colors.grey),
                ),
                Checkbox(
                  value: widget.droit.read,
                  onChanged: (_) {
                    widget.onTapRead(widget.droit.index);
/*                     if (widget.droit.index == 10) {
                      for (var d in widget.userDroits.droits) {
                        d.read = !d.read;
                        setState(() {});
                      }
                    } else {
                      widget.droit.read = !widget.droit.read;
                    } */
                  },
                ),
                const Text(
                  'Modifier',
                  style: TextStyle(color: Colors.grey),
                ),
                Checkbox(
                  value: widget.droit.write,
                  onChanged: (_) {
                    widget.onTapWrite(widget.droit.index);
/*                     if (widget.droit.index == 10) {
                      for (var d in widget.userDroits.droits) {
                        d.write = !d.write;
                        setState(() {});
                      }
                    } else {
                      widget.droit.write = !widget.droit.write;
                      setState(() {});
                    } */
                  },
                ),
              ],
            )),
      ],
    );
  }
}
