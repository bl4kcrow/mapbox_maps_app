import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullscreenMap extends StatefulWidget {
  const FullscreenMap({super.key});

  @override
  State<FullscreenMap> createState() => _FullscreenMapState();
}

class _FullscreenMapState extends State<FullscreenMap> {
  static const String accessToken = String.fromEnvironment(
    'PUBLIC_ACCESS_TOKEN',
  );
  static const LatLng centerPoint =
      LatLng(19.33201009850971, -99.19220425882736);
  static const String pointOfInterestStyle =
      'mapbox://styles/bl4kcrow/cldcmn3ov000601s6tyet3ia7';

  bool isTrafficStyle = true;
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Style loaded :)"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );

    final ByteData bytes = await rootBundle.load('assets/icons8-estadio-50.png');
    final Uint8List bytesList = bytes.buffer.asUint8List();

    await mapController?.addImage(
      'customIcon',
      bytesList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: accessToken,
        initialCameraPosition: const CameraPosition(
          target: centerPoint,
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        styleString: isTrafficStyle ? MapboxStyles.TRAFFIC_DAY : pointOfInterestStyle,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.emoji_symbols_rounded),
              onPressed: () => mapController?.addSymbol(
                const SymbolOptions(
                  geometry: centerPoint,
                  iconImage: 'customIcon',
                  iconSize: 2.0,
                  textOffset: Offset(0.0, 2.0),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            FloatingActionButton(
              child: const Icon(Icons.zoom_in_rounded),
              onPressed: () =>
                  mapController?.animateCamera(CameraUpdate.zoomIn()),
            ),
            const SizedBox(height: 5.0),
            FloatingActionButton(
              child: const Icon(Icons.zoom_out_rounded),
              onPressed: () =>
                  mapController?.animateCamera(CameraUpdate.zoomOut()),
            ),
            const SizedBox(height: 5.0),
            FloatingActionButton(
              child: const Icon(Icons.swap_horiz),
              onPressed: () => setState(
                () => isTrafficStyle = !isTrafficStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
