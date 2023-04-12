import 'package:flutter/material.dart';
import 'package:newgps/src/services/newgps_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolumeWidget extends StatefulWidget {
  const VolumeWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VolumeWidgetState createState() => _VolumeWidgetState();
}

class _VolumeWidgetState extends State<VolumeWidget> {
  @override
  void initState() {
    super.initState();

    _getInitVolumeState();
  }

  _getInitVolumeState() {
    double? res = shared.sharedPreferences.getDouble('volume');
    volume = res ?? 1.0;
  }

  double volume = 1.0;

  @override
  Widget build(BuildContext context) {
    bool mute = volume == 1.0 ? false : true;
    return IconButton(
      icon: Icon(
        mute ? Icons.volume_off_sharp : Icons.volume_up,
      ),
      iconSize: 22,
      onPressed: () async {
        if (mute) {
          await NewgpsService.audioPlayer.setVolume(1);
          volume = 1.0;
        } else {
          await NewgpsService.audioPlayer.setVolume(0);
          volume = 0.0;
        }
        setState(() {});
        shared.sharedPreferences.setDouble('volume', volume);
      },
    );
  }

  void setSharedPreferecences(double volume) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('volume', volume);
  }
}
