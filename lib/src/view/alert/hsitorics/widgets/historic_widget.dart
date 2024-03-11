import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import '../notif_historic_provider.dart';

class BuildSearchHistoric extends StatefulWidget {
  const BuildSearchHistoric({super.key});

  @override
  State<BuildSearchHistoric> createState() => _BuildSearchHistoricState();
}

class _BuildSearchHistoricState extends State<BuildSearchHistoric> {
  bool _init = true;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));
    NotifHistoricPorvider porvider =
        Provider.of<NotifHistoricPorvider>(context, listen: false);
    return Container(
      width: 500,
      margin: const EdgeInsets.fromLTRB(10, 3, 0, 3),
      child: Autocomplete<Device>(
        fieldViewBuilder: (BuildContext context, TextEditingController _,
            FocusNode focusNode, Function onFieldSubmitted) {
          if (_init) {
            porvider.autoSearchController = _;
            porvider.handleSelectDevice();
            _init = false;
          } else {
            porvider.autoSearchController = _;
          }

          return fieldViewBuilderWidget(
              porvider, outlineInputBorder, focusNode, onFieldSubmitted);
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
            notifHistoricPorvider: porvider,
            devices: devices.toList(),
            onSelectDevice: deviceFunc,
          );
        },
      ),
    );
  }

  Widget fieldViewBuilderWidget(
      NotifHistoricPorvider notifHistoricPorvider,
      OutlineInputBorder outlineInputBorder,
      FocusNode focusNode,
      Function onFieldSubmitted) {
    return BuildTextField(
      focusNode: focusNode,
      notifHistoricPorvider: notifHistoricPorvider,
      outlineInputBorder: outlineInputBorder,
    );
  }
}

class BuildTextField extends StatefulWidget {
  final NotifHistoricPorvider notifHistoricPorvider;
  final FocusNode focusNode;
  final OutlineInputBorder outlineInputBorder;
  const BuildTextField({
    super.key,
    required this.notifHistoricPorvider,
    required this.outlineInputBorder,
    required this.focusNode,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,

      child: TextFormField(
        autocorrect: false,
        autovalidateMode: AutovalidateMode.disabled,
        enableIMEPersonalizedLearning: false,
        enableInteractiveSelection: false,
        enableSuggestions: false,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        onTap: () =>
            widget.notifHistoricPorvider.autoSearchController.text = '',
        maxLines: 1,
        onFieldSubmitted: (_) =>
            widget.notifHistoricPorvider.handleSelectDevice(),
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          suffixText: widget.focusNode.hasFocus
              ? ''
              : '${deviceProvider.devices.length}',
          suffixStyle:  GoogleFonts.roboto(
              fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.notifHistoricPorvider.autoSearchController,
        focusNode: widget.focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final List<Device> devices;
  final void Function(Device) onSelectDevice;
  final NotifHistoricPorvider notifHistoricPorvider;

  const OptionViewBuilderWidget({
    super.key,
    required this.devices,
    required this.onSelectDevice,
    required this.notifHistoricPorvider,
  });

  Widget _buildToutsWidget(
      NotifHistoricPorvider notifHistoricPorvider, BuildContext context) {
    DeviceProvider deviceProvider =
        Provider.of<DeviceProvider>(context, listen: false);
    return InkWell(
                    hoverColor: Colors.transparent,

      onTap: () async {
        notifHistoricPorvider.deviceID = 'all';
        notifHistoricPorvider.handleSelectDevice();
        FocusScope.of(context).requestFocus(FocusNode());
        notifHistoricPorvider.fetchDeviceFromSearchWidget();
      },
      child: Container(
        height: 35,

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
            const Text(
              'Touts les véhicules',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${deviceProvider.devices.length}",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
                      hoverColor: Colors.transparent,

        onTap: () {
          notifHistoricPorvider.handleSelectDevice();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(

          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.8
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: AppConsts.mainColor, width: AppConsts.borderWidth),
                  borderRadius: BorderRadius.circular(AppConsts.mainradius)),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                                                width: 497,

/*                   constraints: BoxConstraints(
                    maxHeight: _isPortrait
                        ? (size.height * 0.43)
                        : (bottom * 0.4),
                  ), */
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: devices.map<Widget>((device) {
                      return OptionItem(
                        onSelectDevice: onSelectDevice,
                        notifHistoricPorvider: notifHistoricPorvider,
                        device: device,
                      );
                    }).toList()
                      ..insert(
                          0, _buildToutsWidget(notifHistoricPorvider, context)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final Device device;
  const OptionItem({
    super.key,
    required this.onSelectDevice,
    required this.notifHistoricPorvider,
    required this.device,
  });

  final void Function(Device p1) onSelectDevice;
  final NotifHistoricPorvider notifHistoricPorvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
                    hoverColor: Colors.transparent,

      onTap: () async {
        onSelectDevice(device);
        notifHistoricPorvider.selectedDevice = device;
        notifHistoricPorvider.deviceID = device.deviceId;
        notifHistoricPorvider.fetchDeviceFromSearchWidget();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                device.description,
              ),
              _BuildStatuWidget(device: device)
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildStatuWidget extends StatelessWidget {
  const _BuildStatuWidget({
    required this.device,
  });

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