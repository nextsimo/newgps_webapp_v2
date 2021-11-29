import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapZoomWidget extends StatelessWidget {
  final Completer<GoogleMapController> completer;
  final double top;

  const MapZoomWidget({Key? key, required this.completer, this.top = 50})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[50],
          border: Border.all(
            width: 1.2,
            color: Colors.grey[400]!,
          )),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 12,
                  onPressed: () {
                    completer.future.then((googleMpa) {
                      googleMpa.animateCamera(CameraUpdate.zoomIn());
                    });
                    //controller?.animateCamera(CameraUpdate.zoomIn());
                  }),
            ),
          ),
          Container(
            height: 1.2,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Center(
              child: IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 12,
                  onPressed: () {
                    completer.future.then((googleMpa) {
                      googleMpa.animateCamera(CameraUpdate.zoomOut());
                    });
                  }),
            ),
          )
        ],
      ),
    );
  }
}
