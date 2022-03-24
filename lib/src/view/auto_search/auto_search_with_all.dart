import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchDeviceWithAll extends StatefulWidget {
  const AutoSearchDeviceWithAll({Key? key}) : super(key: key);

  @override
  State<AutoSearchDeviceWithAll> createState() =>
      _AutoSearchDeviceWithAllState();
}

class _AutoSearchDeviceWithAllState extends State<AutoSearchDeviceWithAll> {
  late FocusNode _focusNode;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);

    context.select<LastPositionProvider, bool>((p) => p.notifyMap);
    return GestureDetector(
      onHorizontalDragStart: (_) {
        lastPositionProvider.handleSelectDevice();
      },
      onTap: () {
        lastPositionProvider.handleSelectDevice();
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topLeft,
        child: Container(
          width: 400,
          margin: const EdgeInsets.all(AppConsts.outsidePadding),
          child: Autocomplete<Device>(
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
              lastPositionProvider.autoSearchController = _;
              _focusNode = focusNode;
              lastPositionProvider.handleSelectDevice(notify: false);
              return fieldViewBuilderWidget(
                lastPositionProvider,
                outlineInputBorder,
                _focusNode,
                onFieldSubmitted,
              );
            },
            displayStringForOption: (d) => d.description,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return deviceProvider.devices;
              }
              return deviceProvider.devices.where(
                (device) {
                  return device.description
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                void Function(Device device) deviceFunc, devices) {
              return OptionViewBuilderWidget(
                focusNode: _focusNode,
                devices: devices.toList(),
                onSelectDevice: deviceFunc,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      LastPositionProvider lastPositionProvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted) {
    return BuildTextField(
      focusNode: focusNode,
      lastPositionProvider: lastPositionProvider,
      outlineInputBorder: outlineInputBorder,
    );
  }
}

class BuildTextField extends StatefulWidget {
  final LastPositionProvider lastPositionProvider;
  final FocusNode focusNode;
  final OutlineInputBorder outlineInputBorder;
  const BuildTextField({
    Key? key,
    required this.lastPositionProvider,
    required this.outlineInputBorder,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Device> devices =
        context.select<DeviceProvider, List<Device>>((__) => __.devices);

    if (devices.isEmpty) {
      widget.lastPositionProvider.autoSearchController.text =
          'Chargement des véhicules..';
    } else if (widget.lastPositionProvider.autoSearchController.text ==
        'Chargement des véhicules..') {
      widget.lastPositionProvider.autoSearchController.text =
          'Touts les véhicules';
    }

    return SizedBox(
      height: 35,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        onTap: () {
          widget.lastPositionProvider.enableZoomGesture = false;
          widget.lastPositionProvider.autoSearchController.text = '';
        },
        maxLines: 1,
        onFieldSubmitted: widget.lastPositionProvider.onTapEnter,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          //suffix: Text('${deviceProvider.devices.length}'),
          //suffixIconConstraints: const BoxConstraints(),
          suffixText: (widget.focusNode.hasFocus || devices.isEmpty)
              ? ''
              : '${deviceProvider.devices.length}',
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.lastPositionProvider.autoSearchController,
        focusNode: widget.focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final FocusNode focusNode;
  final List<Device> devices;
  final void Function(Device) onSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectDevice,
    required this.focusNode,
  }) : super(key: key);

  Widget _buildToutsWidget(
      LastPositionProvider lastPositionProvider, BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    return InkWell(
      onTap: () async {
        lastPositionProvider.enableZoomGesture = true;
        lastPositionProvider.markersProvider.fetchGroupesDevices = true;
        lastPositionProvider.handleSelectDevice();
        deviceProvider.infoModel = null;
        focusNode.unfocus();
        lastPositionProvider.fetchDevices(fromSelect: true);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: AppConsts.mainColor, width: AppConsts.borderWidth),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Touts les véhicules'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${deviceProvider.devices.length}"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 400,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppConsts.mainColor, width: AppConsts.borderWidth),
            borderRadius: BorderRadius.circular(AppConsts.mainradius)),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.75,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: devices.map<Widget>((device) {
                return OptionItem(
                  focusNode: focusNode,
                  onSelectDevice: onSelectDevice,
                  lastPositionProvider: lastPositionProvider,
                  device: device,
                );
              }).toList()
                ..insert(0, _buildToutsWidget(lastPositionProvider, context)),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final FocusNode focusNode;
  final Device device;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.lastPositionProvider,
    required this.device,
    required this.focusNode,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;
  final LastPositionProvider lastPositionProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _BuildStatuWidget(device: device),
      title: Text(
        device.description,
      ),
      onTap: () async {
        lastPositionProvider.enableZoomGesture = true;
        onSelectDevice(device);
        deviceProvider.selectedDevice = device;
        focusNode.unfocus();
        await lastPositionProvider.fetchDevice(device.deviceId,
            isSelected: true);
        //lastPositionProvider.moveCamera(device, zoom: 8.5);
      },
      minVerticalPadding: 0,
    );
  }
}

class _BuildStatuWidget extends StatelessWidget {
  const _BuildStatuWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color.fromRGBO(device.colorR, device.colorG, device.colorB, 1),
      ),
      child: Text(
        device.statut,
        style:  GoogleFonts.roboto(color: Colors.white),
      ),
    );
  }
}
