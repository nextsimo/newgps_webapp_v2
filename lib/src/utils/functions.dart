import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:newgps/src/view/historic/historic_provider.dart';
import 'package:intl/intl.dart';
import 'package:newgps/src/view/last_position/last_position_provider.dart';
import 'package:newgps/src/view/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

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

class FormValidatorService {
  static String? isNotEmpty(String? value) {
    if (value!.isEmpty) {
      return "Champs requis";
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
}

Future<void> fetchInitData(
    {required HistoricProvider historicProvider,
    required LastPositionProvider lastPositionProvider,
    required BuildContext context}) async {
  SavedAcountProvider savedAcountProvider =
      Provider.of<SavedAcountProvider>(context, listen: false);
  await savedAcountProvider.fetchUserDroits();
  await deviceProvider.init(context);
  await lastPositionProvider.init(context);
}

Future<void> playAudio(String audio) async {
  try {
    await NewgpsService.audioPlayer.setLanguage("fr-FR");
    await NewgpsService.audioPlayer.stop();
    await NewgpsService.audioPlayer.speak(audio);
  } catch (e) {
    log(e.toString());
  }
}
