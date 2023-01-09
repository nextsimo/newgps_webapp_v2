import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/device_provider.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/locator.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/view/driver_phone/driver_phone_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../view/icon_change/change_icon_view.dart';
import 'buttons/outlined_button.dart';

class FloatingGroupWindowInfo extends StatefulWidget {
  final Device device;
  final bool showOnOffDevice;
  final bool showCallDriver;
  final void Function()? onClose;

  const FloatingGroupWindowInfo(
      {Key? key,
      required this.device,
      this.onClose,
      this.showOnOffDevice = true,
      this.showCallDriver = true})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FloatingGroupWindowInfoState createState() =>
      _FloatingGroupWindowInfoState();
}

class _FloatingGroupWindowInfoState extends State<FloatingGroupWindowInfo> {
  String address = '';

  @override
  void initState() {
    super.initState();
    _setTheAddress();
  }

  Future<void> _setTheAddress() async {
    Future.microtask(() async {
      address = await api.get(
          url:
              '/device/address/${widget.device.latitude}/${widget.device.longitude}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider provider =
        Provider.of<DeviceProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        widget.onClose!();
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            widget.onClose!();
          },
          child: Container(
            width: DeviceSize.width,
            alignment: Alignment.bottomCenter,
            color: Colors.transparent,
            child: Container(
              width: DeviceSize.width * 0.35,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConsts.mainradius),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          padding: const EdgeInsets.all(5),
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onClose!();
                          })),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Matricule
                          if (widget.device.description.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  widget.device.description,
                                  style: GoogleFonts.roboto(
                                      color: AppConsts.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                IconChangeView(
                                  selectedDevice: widget.device,
                                  closeIconChangeView: () {
                                    widget.onClose!();
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.commute, color: AppConsts.blue),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                      text: "État: ",
                                      style: GoogleFonts.roboto(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                      children: [
                                    TextSpan(
                                        text: widget.device.statut,
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54))
                                  ])),
                            ],
                          ),
                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: AppConsts.mainColor),
                              const SizedBox(width: 5),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        text: "Date: ",
                                        style: GoogleFonts.roboto(
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        children: [
                                      TextSpan(
                                          text: formatDeviceDate(
                                              widget.device.dateTime),
                                          style: GoogleFonts.roboto(
                                            color: Colors.black54,
                                          ))
                                    ])),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(Icons.av_timer,
                                  color: AppConsts.mainColor),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                text: "Vitesse: ",
                                style: GoogleFonts.roboto(
                                    color: Colors.black.withOpacity(0.7)),
                                children: [
                                  TextSpan(
                                      text: "${widget.device.speedKph} Km/H")
                                ],
                              )),
                            ],
                          ),
                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppConsts.blue),
                              const SizedBox(width: 5),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        text: "Adresse: ",
                                        style: GoogleFonts.roboto(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                        children: [
                                      if (address.isNotEmpty)
                                        TextSpan(
                                          text: address,
                                          style: GoogleFonts.roboto(
                                              color: Colors.black54),
                                        ),
                                    ])),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),

                          Row(
                            children: [
                              const Icon(Icons.speed,
                                  color: AppConsts.mainColor),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(
                                      text: "Kilométrage: ",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black.withOpacity(0.7)),
                                      children: [
                                    TextSpan(
                                        text:
                                            "${widget.device.odometerKm.toInt()} Km",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black54))
                                  ])),
                            ],
                          ),

                          const SizedBox(height: 7),
                          if (widget.showCallDriver)
                            MainButton(
                              height: 35,
                              icon: Icons.call,
                              onPressed: () {
                                locator<DriverPhoneProvider>().checkPhoneDriver(
                                  context: context,
                                  device: widget.device,
                                  sDevice: widget.device,
                                  callNewData: () async =>
                                      await deviceProvider.fetchDevices(),
                                );
                              },
                              label: 'Appele conducteur',
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.showOnOffDevice)
                        Row(
                          children: [
                            Expanded(
                              child: MainButton(
                                height: 35,
                                onPressed: () async {
                                  await _showStartStopDilaog(context, provider,
                                      'IgnitionEnable:TCP', 'démarrer');
                                },
                                label: 'Démarrer',
                                backgroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: MainButton(
                              height: 35,
                              onPressed: () async {
                                await _showStartStopDilaog(context, provider,
                                    'IgnitionDisable:TCP', 'arrêter');
                              },
                              label: 'Arrêter',
                              backgroundColor: Colors.red,
                            )),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: MainButton(
                              height: 35,
                              onPressed: () async {
                                Position pos = await GeolocatorPlatform.instance
                                    .getCurrentPosition();
                                launchUrlString(
                                    'https://www.google.com/maps/dir/${pos.latitude},${pos.longitude}/${widget.device.latitude},${widget.device.longitude}');
                              },
                              label: 'Iténiraire',
                              icon: Icons.directions,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: MainButton(
                            height: 35,
                            onPressed: () async {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      'http://maps.google.com/?q=${widget.device.latitude},${widget.device.longitude}'));
                            },
                            label: 'Copie localision',
                            backgroundColor: Colors.blueAccent,
                          )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showStartStopDilaog(BuildContext context, DeviceProvider provider,
      String command, String status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(
              Icons.warning_rounded,
              color: AppConsts.mainColor,
              size: 44,
            ),
            const SizedBox(height: 10),
            Text('Etes-vous sur de $status ce véhicule'),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                CustomOutlinedButton(
                  width: 90,
                  onPressed: () => Navigator.of(context).pop(),
                  label: 'Non',
                ),
                const SizedBox(width: 10),
                MainButton(
                  onPressed: () async => await provider.startStopDevice(
                      command, context, widget.device),
                  width: 90,
                  label: 'Oui',
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
