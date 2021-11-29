import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

class UserDevicesUi extends StatefulWidget {
  final User user;
  const UserDevicesUi({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDevicesUi> createState() => _UserDevicesUiState();
}

class _UserDevicesUiState extends State<UserDevicesUi> {
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
          child: _ShowListDevices(
            closeMenu: closeMenu,
            user: widget.user,
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
            width: 250,
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
              children: [
                const SizedBox(width: 4),
                Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 17,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ajouter vehicule',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
/*         Expanded(
          child: Center(
            child: MainButton(
              onPressed: () async {
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              },
              label: 'Ajouter vehicule',
              backgroundColor: AppConsts.mainColor,
              height: 30,
              width: 120,
              factor: 0.7,
            ),
          ),
        ), */
        const SizedBox(width: 10),
        Text(
          '${widget.user.devices.length} Selectioné',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ShowListDevices extends StatefulWidget {
  final User user;
  final Function closeMenu;
  const _ShowListDevices(
      {Key? key, required this.closeMenu, required this.user})
      : super(key: key);

  @override
  State<_ShowListDevices> createState() => _ShowListDevicesState();
}

class _ShowListDevicesState extends State<_ShowListDevices> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    DeviceProvider deviceProvider = Provider.of(context, listen: false);
    devices = deviceProvider.devices;
    devices.sort((Device device1, Device device2) {
      if (widget.user.devices.contains(device1.deviceId)) {
        return -1;
      } else if (widget.user.devices.contains(device2.deviceId)) {
        return 1;
      } else {
        return 0;
      }
    });
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
          children: [
            _searchDevices(),
            _devicesList(context),
          ],
        ),
      ),
    );
  }

  Widget _searchDevices() {
    DeviceProvider deviceProvider = Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: SearchWidget(
            autoFocus: true,
            hint: 'Rechercher',
            onChnaged: (_) {
              if (_.isEmpty) {
                devices = deviceProvider.devices;
              }
              devices = devices
                  .where((d) =>
                      d.description.toUpperCase().contains(_.toUpperCase()))
                  .toList();
            },
          ),
        ),
        CloseButton(
          color: Colors.black,
          onPressed: () {
            widget.closeMenu();
          },
        ),
      ],
    );
  }

  Widget _devicesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        Device device = devices.elementAt(index);
        String deviceName = device.description;
        bool selected = widget.user.devices.contains(device.deviceId);
        return CheckedMatricule(
          device: deviceName,
          checked: selected,
          deviceID: device.deviceId,
          user: widget.user,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: devices.length,
    );
  }
}

class CheckedMatricule extends StatefulWidget {
  final String device;
  final User user;
  final String deviceID;
  final bool checked;
  const CheckedMatricule(
      {Key? key,
      required this.device,
      required this.checked,
      required this.user,
      required this.deviceID})
      : super(key: key);

  @override
  State<CheckedMatricule> createState() => _CheckedMatriculeState();
}

class _CheckedMatriculeState extends State<CheckedMatricule> {
  late bool _checked;
  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: _checked,
            onChanged: (bool? check) {
              if (check!) {
                widget.user.devices.add(widget.deviceID);
              } else if (!check) {
                widget.user.devices.remove(widget.deviceID);
              }
              _checked = check;
              setState(() {});
            }),
        const SizedBox(width: 10),
        Text(widget.device),
      ],
    );
  }
}
