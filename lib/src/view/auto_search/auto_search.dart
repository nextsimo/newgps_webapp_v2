import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';

class AutoSearchDevice extends StatelessWidget {
  final Future<void> Function(Device device)? onSelectDeviceFromOtherView;

  const AutoSearchDevice({Key? key, this.onSelectDeviceFromOtherView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final HistoricProvider historicProvider =
        Provider.of<HistoricProvider>(context, listen: false);

    if (deviceProvider.devices.isEmpty) return const SizedBox();
    return GestureDetector(
      onHorizontalDragStart: (_) {
        deviceProvider.handleSelectDevice();
        historicProvider.enableZoomGesture = true;
      },
      onTap: () {
        deviceProvider.handleSelectDevice();
        historicProvider.enableZoomGesture = true;
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
              deviceProvider.autoSearchController = _;
              deviceProvider.handleSelectDevice();
              return fieldViewBuilderWidget(deviceProvider, outlineInputBorder,
                  focusNode, onFieldSubmitted, historicProvider);
            },
            displayStringForOption: (d) => d.description,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return deviceProvider.devices;

              return deviceProvider.devices.where(
                (device) {
                  return device.description
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                },
              );
            },
            onSelected: onSelectDeviceFromOtherView,
            optionsViewBuilder: (BuildContext context,
                void Function(Device device) deviceFunc, devices) {
              return OptionViewBuilderWidget(
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
      DeviceProvider deviceProvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted,
      HistoricProvider historicProvider) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        maxLines: 1,
        onFieldSubmitted: historicProvider.onTapEnter,
        onTap: () {
          deviceProvider.autoSearchController.text = '';
          historicProvider.enableZoomGesture = false;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
        ),
        controller: deviceProvider.autoSearchController,
        focusNode: focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<Device> devices;
  final void Function(Device) onSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
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
                    onSelectDevice: onSelectDevice,
                    deviceProvider: deviceProvider,
                    device: device,
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final Device device;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.deviceProvider,
    required this.device,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;
  final DeviceProvider deviceProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _BuildStatuWidget(device: device),
      title: Text(
        device.description,
      ),
      onTap: () {
        LastPositionProvider lastPositionProvider =
            Provider.of<LastPositionProvider>(context, listen: false);
        lastPositionProvider.fetchAll = false;

        onSelectDevice(device);
        deviceProvider.selectedDevice = device;
        FocusScope.of(context).unfocus();
        onSelectDevice(device);
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
