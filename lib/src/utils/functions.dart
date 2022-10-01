import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/models/account.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:intl/intl.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:url_launcher/url_launcher.dart';

const String fuelLocalDataKey = 'fuel';
const String batteryLocalDataKey = 'battery';
const String speedLocalDataKey = 'speed';
const String geozoneLocalDataKey = 'geozone';
const String startUpLocalDataKey = 'startup';
const String imobilityLocalDataKey = 'imobility';
const String hoodLocalDataKey = 'hood';
const String oilChangelocalDataKey = 'oil_change';
const String towingLocalDataKey = 'towing';

String formatDeviceDate(DateTime dateTime, [bool time = true]) {
  late DateFormat validFormatter;
  if (time) {
    validFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  } else {
    validFormatter = DateFormat('dd/MM/yyyy');
  }
  String formatted;
  try {
    formatted = validFormatter.format(dateTime);
  } catch (e) {
    return '';
  }
  return formatted;
}

String formatSimpleDate(DateTime dateTime, [bool time = true]) {
  late DateFormat validFormatter;
  if (time) {
    validFormatter = DateFormat('dd/MM/yyyy');
  } else {
    validFormatter = DateFormat('dd/MM/yyyy');
  }
  String formatted;
  try {
    formatted = validFormatter.format(dateTime);
  } catch (e) {
    return '';
  }
  return formatted;
}

String formatToTime(DateTime dateTime) {
  final DateFormat validFormatter = DateFormat('HH:mm');
  String formatted;
  try {
    formatted = validFormatter.format(dateTime);
  } catch (e) {
    return '';
  }
  return formatted;
}

String formatToTimeWithSeconds(DateTime dateTime) {
  final DateFormat validFormatter = DateFormat('HH:mm:ss');
  String formatted;
  try {
    formatted = validFormatter.format(dateTime);
  } catch (e) {
    return '';
  }
  return formatted;
}


class FormValidatorService {
  static String? isNotEmpty(String? value) {
    if (value!.isEmpty) {
      return "Champs obligatoire";
    }
    return null;
  }

  static String? isNumber(String? value) {
    if (value!.isNotEmpty) {
      return double.tryParse(value) == null ? "Doit être un nombre" : null;
    }
    return null;
  }

  static isUrl(String url) {
    bool _validURL = url.split('.').length == 2 || url.split('.').length == 3;
    if (!_validURL) return "Entrez une URL valide";
    return null;
  }

  static isEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? 'Entre un email valide' : null;
  }

  static isStrongPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return (!regExp.hasMatch(value)) ? 'Must be strong password' : null;
  }

  static String? isMoroccanPhoneNumber(String? value) {
    String? res = isNotEmpty(value);
    if (res != null) return res;
    String pattern = r'(\+212|0)([ \-_/]*)(\d[ \-_/]*){9}';

    RegExp regex = RegExp(pattern);

    return (!regex.hasMatch(value!))
        ? "Le numéro de téléphone n'est pas valide"
        : null;
  }

  static String? isMoroccanPhoneNumberNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return isMoroccanPhoneNumber(value);
  }
}
/* 
Future<void> fetchInitData(
    {required HistoricProvider historicProvider,
    required LastPositionProvider lastPositionProvider,
    required BuildContext context}) async {
  SavedAcountProvider savedAcountProvider =
      Provider.of<SavedAcountProvider>(context, listen: false);
  await savedAcountProvider.fetchUserDroits();
  await deviceProvider.init(context);
  await lastPositionProvider.init(context);
} */

void fetchInitData(
    {required LastPositionProvider lastPositionProvider,
    required BuildContext context}) async {

  deviceProvider.init(context);
  lastPositionProvider.init(context);
}


Future<void> playAudio(String audio) async {
  try {
    await NewgpsService.audioPlayer.setLanguage("fr-FR");
    await NewgpsService.audioPlayer.stop();
    await NewgpsService.audioPlayer.speak(audio);
  } catch (e) {
    //log(e.toString());
  }
}

Future<String> _getLastReadDate(String type) async {
  Account? account = shared.getAccount();
  String res = await api.post(
    url: '/alert/historic/read',
    body: {
      'type': type,
      'device_token': await getDeviceToken(),
      'account_id': account?.account.accountId,
    },
  );

  return json.decode(res)['last_read_date'];
}

final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();


  Future<String?> getDeviceToken() async {
    WebBrowserInfo webBrowserInfo = await _deviceInfo.webBrowserInfo;
    return "${webBrowserInfo.appName}-${webBrowserInfo.platform}-${webBrowserInfo.productSub}";
  }

Future<Map<String, dynamic>> getBody() async {
  String lastFuelReadDate = await _getLastReadDate(fuelLocalDataKey);
  //shared.sharedPreferences.getString(fuelLocalDataKey) ?? '2001-12-23';
  String lastBatteryReadDate = await _getLastReadDate(batteryLocalDataKey);
  //shared.sharedPreferences.getString(batteryLocalDataKey) ?? '2001-12-23';
  String lastSpeedReadDate = await _getLastReadDate(speedLocalDataKey);
  // shared.sharedPreferences.getString(speedLocalDataKey) ?? '2001-12-23';
  String lastgeozoneReadDate = await _getLastReadDate(geozoneLocalDataKey);
  String laststartUpReadDate = await _getLastReadDate(startUpLocalDataKey);
  String lastImobilityReadDate = await _getLastReadDate(imobilityLocalDataKey);
  String lastHoodReadDate = await _getLastReadDate(hoodLocalDataKey);
  String lastOilChangeReadDate = await _getLastReadDate(oilChangelocalDataKey);
  String lastTowingReadDate = await _getLastReadDate(towingLocalDataKey);
  // shared.sharedPreferences.getString(geozoneLocalDataKey) ?? '2001-12-23';

  Account? account = shared.getAccount();
  return {
    'last_fuel_histo_read_date': lastFuelReadDate,
    'last_battery_histo_read_date': lastBatteryReadDate,
    'last_speed_histo_read_date': lastSpeedReadDate,
    'last_geozone_histo_read_date': lastgeozoneReadDate,
    'last_startup_histo_read_date': laststartUpReadDate,
    'last_imobility_histo_read_date': lastImobilityReadDate,
    'last_hood_histo_read_date': lastHoodReadDate,
    'last_oil_change_histo_read_date': lastOilChangeReadDate,
    'last_towing_histo_read_date': lastTowingReadDate,
    'account_id': account?.account.accountId
  };
}

String whatsapFormat(DateTime dateTime) {
  DateTime now = DateTime.now();
  late String format;

  if (now.day == dateTime.day &&
      dateTime.year == now.year &&
      now.month == dateTime.month) {
    return "Aujourd'hui";
  } else if (dateTime.year == now.year &&
      now.month == dateTime.month &&
      ((now.day - dateTime.day) == 1)) {
    return 'Hier';
  } else if (dateTime.year == now.year && now.month == dateTime.month) {
    format = 'EEEE';
  } else if (dateTime.year == now.year) {
    format = 'E, dd MMM';
  } else {
    format = 'dd MMM yyyy';
  }

  final DateFormat formatter = DateFormat(format, 'fr');

  return formatter.format(dateTime);
}

String whatsapFormatOnlyTime(DateTime dateTime) {
  String format = 'HH:mm';

  final DateFormat formatter = DateFormat(format, 'fr');

  return formatter.format(dateTime);
}

String whatsapFormatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  late String format;

  if (now.day == dateTime.day &&
      dateTime.year == now.year &&
      now.month == dateTime.month) {
    format = 'HH:mm';
  } else if (dateTime.year == now.year && now.month == dateTime.month) {
    format = 'EEEE';
  } else if (dateTime.year == now.year) {
    format = 'E, dd MMM';
  } else {
    format = 'dd MMM yyyy';
  }
  final DateFormat formatter = DateFormat(format, 'fr');
  return formatter.format(dateTime);
}

void showCallConducteurDialog(BuildContext context, Device device) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(17),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainButton(
                  onPressed: () {
                      launch('tel:${device.phone1}', webOnlyWindowName: '_self');
                  },
                  icon: Icons.phone_forwarded_rounded,
                  label: device.phone1,
                ),
                const SizedBox(height: 10),
                if (device.phone2.isNotEmpty)
                  MainButton(
                    onPressed: () {
                      launch('tel:${device.phone2}', webOnlyWindowName: '_self');
                    },
                    icon: Icons.phone_forwarded_rounded,
                    label: device.phone2,
                  ),
              ],
            ),
          ),
        );
      });
}
