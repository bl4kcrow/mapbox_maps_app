import 'package:flutter/material.dart';
import 'package:mapbox_maps_app/views/fullscreen_map.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: FullscreenMap(),
      ),
    );
  }
}