import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/styles.dart';

typedef HandleSelectDevice = void Function();
typedef OnClickAll = void Function();
typedef InitController = void Function(TextEditingController c);
typedef ClearTextController = void Function();
typedef OnSelectDevice = void Function(Device device);

class AutoSearchWithAllWidget extends StatefulWidget {
  final InitController initController;
  final HandleSelectDevice handleSelectDevice;
  final OnClickAll onClickAll;
  final ClearTextController clearTextController;
  final OnSelectDevice onSelectDevice;
  final TextEditingController controller;
  const AutoSearchWithAllWidget(
      {Key? key,
      required this.initController,
      required this.handleSelectDevice,
      required this.onClickAll,
      required this.clearTextController,
      required this.controller,
      required this.onSelectDevice})
      : super(key: key);

  @override
  State<AutoSearchWithAllWidget> createState() =>
      _AutoSearchWithAllWidgetState();
}

class _AutoSearchWithAllWidgetState extends State<AutoSearchWithAllWidget> {
  bool _init = true;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            color: AppConsts.mainColor, width: AppConsts.borderWidth));

    return GestureDetector(
      onHorizontalDragStart: (_) {
        widget.handleSelectDevice();
      },
      onTap: () {
        widget.handleSelectDevice();
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Container(
          width: 400,
          margin: const EdgeInsets.all(AppConsts.outsidePadding),
          child: Autocomplete<Device>(
            fieldViewBuilder: (BuildContext context, TextEditingController _,
                FocusNode focusNode, Function onFieldSubmitted) {
              if (_init) {
                widget.initController(_);
                widget.handleSelectDevice();
                _init = false;
              } else {
                widget.initController(_);
              }
              return BuildTextField(
                rebuild: () {
                  widget.clearTextController();
                  setState(() {});
                },
                controller: widget.controller,
                clearTextController: widget.clearTextController,
                handleSelectDevice: widget.handleSelectDevice,
                focusNode: focusNode,
                outlineInputBorder: outlineInputBorder,
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
                onSelectDevice2: widget.onSelectDevice,
                handleSelectDevice: widget.handleSelectDevice,
                onClickAll: widget.onClickAll,
                devices: devices.toList(),
                onSelectDevice: deviceFunc,
              );
            },
          ),
        ),
      ),
    );
  }
}

class BuildTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final HandleSelectDevice handleSelectDevice;
  final ClearTextController clearTextController;
  final OutlineInputBorder outlineInputBorder;
  final void Function() rebuild;
  const BuildTextField({
    Key? key,
    required this.outlineInputBorder,
    required this.focusNode,
    required this.clearTextController,
    required this.handleSelectDevice,
    required this.controller,
    required this.rebuild,
  }) : super(key: key);

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        showCursor: true,
        textInputAction: TextInputAction.done,
        scrollPadding: EdgeInsets.zero,
        onTap: () async {
          widget.clearTextController();
          widget.controller.clear();
/*           await Future.delayed(const Duration(milliseconds: 250));
          widget.rebuild(); */
        },
        maxLines: 1,
        onFieldSubmitted: (_) => widget.handleSelectDevice(),
        autofocus: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          suffixText: widget.focusNode.hasFocus
              ? ''
              : '${deviceProvider.devices.length}',
          suffixStyle: GoogleFonts.roboto(color: Colors.grey),
          border: widget.outlineInputBorder,
          focusedBorder: widget.outlineInputBorder,
          enabledBorder: widget.outlineInputBorder,
        ),
        controller: widget.controller,
        focusNode: widget.focusNode,
      ),
    );
  }
}

class OptionViewBuilderWidget extends StatelessWidget {
  final OnClickAll onClickAll;
  final OnSelectDevice onSelectDevice2;

  final List<Device> devices;
  final void Function(Device) onSelectDevice;
  final HandleSelectDevice handleSelectDevice;

  const OptionViewBuilderWidget({
    Key? key,
    required this.devices,
    required this.onSelectDevice,
    required this.onClickAll,
    required this.handleSelectDevice,
    required this.onSelectDevice2,
  }) : super(key: key);

  Widget _buildToutsWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        onClickAll();
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.only(left: 6),
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
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          handleSelectDevice();
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
          width: size.width,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: AppConsts.mainColor, width: AppConsts.borderWidth),
                  borderRadius: BorderRadius.circular(AppConsts.mainradius)),
              child: Material(
                color: Colors.transparent,
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: devices.map<Widget>((device) {
                    return OptionItem(
                      onSelectDevice2: onSelectDevice2,
                      onSelectDevice: onSelectDevice,
                      device: device,
                    );
                  }).toList()
                    ..insert(0, _buildToutsWidget(context)),
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
  final OnSelectDevice onSelectDevice2;
  const OptionItem({
    Key? key,
    required this.onSelectDevice,
    required this.device,
    required this.onSelectDevice2,
  }) : super(key: key);

  final void Function(Device p1) onSelectDevice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onSelectDevice(device);
        onSelectDevice2(device);
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(device.description),
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
        style: GoogleFonts.roboto(color: Colors.white),
      ),
    );
  }
}
