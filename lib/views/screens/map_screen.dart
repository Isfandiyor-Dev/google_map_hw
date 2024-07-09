import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  late GoogleMapController myController;
  final LatLng myHome = const LatLng(40.927689, 68.985711);

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: myHome,
              zoom: 15.0,
            ),
            mapType: MapType.normal,
            markers: {
              Marker(
                markerId: const MarkerId("home"),
                icon: BitmapDescriptor.defaultMarker,
                position: myHome,
                infoWindow: const InfoWindow(
                  title: r"Home",
                  snippet: "Bu mening uyim",
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
