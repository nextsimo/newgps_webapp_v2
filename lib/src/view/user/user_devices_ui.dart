import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      style: GoogleFonts.roboto(
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
  late List<Device> devices;

  @override
  void initState() {
    super.initState();
    DeviceProvider deviceProvider = Provider.of(context, listen: false);
    devices = List<Device>.from(deviceProvider.devices);
    devices.sort((Device device1, Device device2) {
      if (widget.user.devices.contains(device1.deviceId)) {
        return -1;
      } else if (widget.user.devices.contains(device2.deviceId)) {
        return 1;
      } else {
        return 0;
      }
    });

    devices.insert(0, emptyDevice);
  }

  Device emptyDevice = Device(
      markerText: '',
      deviceIcon: '',
      description: 'Touts les véhicules',
      deviceId: '',
      dateTime: DateTime.now(),
      latitude: 0,
      longitude: 0,
      address: '',
      distanceKm: 0,
      odometerKm: 0,
      city: '',
      heading: 0,
      speedKph: 0,
      index: 0,
      colorR: 0,
      colorG: 0,
      colorB: 0,
      statut: '',
      markerPng: '',
      phone1: '',
      phone2: '',
      markerTextPng: '');
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
          ontapAllDevice: () {
            if (device.deviceId.isEmpty && !selected) {
              widget.user.devices = List<String>.from(
                  deviceProvider.devices.map((e) => e.deviceId))
                ..add('');
              setState(() {});
            } else if (device.deviceId.isEmpty) {
              widget.user.devices.clear();
              setState(() {});
            } else {
              if (selected) {
                widget.user.devices.remove(device.deviceId);
                widget.user.devices.remove('');
              } else {
                widget.user.devices.add(device.deviceId);
              }
              setState(() {});
            }
          },
          checked: selected,
          deviceID: device.deviceId,
          user: widget.user,
        );
      },
      separatorBuilder: (_, int index) => index == 0
          ? Container(
              height: 1.3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey,
            )
          : const SizedBox(height: 10),
      itemCount: devices.length,
    );
  }
}

class CheckedMatricule extends StatelessWidget {
  final void Function() ontapAllDevice;
  final String device;
  final User user;
  final String deviceID;
  final bool checked;
  const CheckedMatricule(
      {Key? key,
      required this.device,
      required this.checked,
      required this.user,
      required this.deviceID,
      required this.ontapAllDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: checked,
            onChanged: (bool? check) {
              ontapAllDevice();
/*               if (check!) {
                widget.user.devices.add(widget.deviceID);
              } else if (!check) {
                widget.user.devices.remove(widget.deviceID);
              }
              _checked = check;
              setState(() {}); */
            }),
        const SizedBox(width: 10),
        Text(
          device,
          style: GoogleFonts.roboto(
            color: deviceID.isEmpty ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}
