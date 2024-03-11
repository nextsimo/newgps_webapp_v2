import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapTypeWidget extends StatelessWidget {
  final void Function(MapType) onChange;
  const MapTypeWidget({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MapType>(
      icon: const Icon(
        Icons.map_outlined,
        color: Colors.black,
      ),
      onSelected: onChange,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MapType>>[
        const PopupMenuItem<MapType>(
          value: MapType.normal,
          child: Text('Vue normale'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.hybrid,
          child: Text('Vue hybride'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.satellite,
          child: Text('Vue satellite'),
        ),
        const PopupMenuItem<MapType>(
          value: MapType.terrain,
          child: Text('Vue Terrain'),
        ),
      ],
    );
  }
}
