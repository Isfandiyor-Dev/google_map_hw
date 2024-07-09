import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:lesson_72_permissions/services/location_service.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController myController;
  LatLng myCurrentLocation = const LatLng(41.927689, -122.985711);
  LatLng? selectedLocation;
  @override
  void initState() {
    super.initState();
  }

  Future<void> goToCurrentLocation() async {
    await LocationService.getCurrentLcoation();
    if (LocationService.currentLocation != null) {
      setState(() {
        myCurrentLocation = LatLng(
          LocationService.currentLocation!.latitude!,
          LocationService.currentLocation!.longitude!,
        );
      });
      myController.animateCamera(
        CameraUpdate.newLatLng(myCurrentLocation),
      );
    } else {
      const SnackBar(
        content: Row(
          children: [
            Text("Sizning manzilingizni aniqlab bo'lmadi!"),
          ],
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  final _yourGoogleAPIKey = 'AIzaSyBEjfX9jrWudgRcWl2scld4R7s0LtlaQmQ';
  final _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
              zoom: 10.0,
            ),
            mapType: MapType.normal,
            onTap: (argument) {
              selectedLocation = argument;
              setState(() {});
            },
            markers: {
              Marker(
                markerId: const MarkerId("current"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                position: myCurrentLocation,
                infoWindow: const InfoWindow(
                  title: "Current place",
                  snippet: "Siz turgan joy",
                ),
              ),
              if (selectedLocation != null)
                Marker(
                  markerId: const MarkerId("selected"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: selectedLocation!,
                  infoWindow: const InfoWindow(
                    title: "Selected Place",
                    snippet: "Siz tanlagan joy",
                  ),
                ),
            },
          ),
          Positioned(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: GooglePlacesAutoCompleteTextFormField(
                  textEditingController: _textController,
                  googleAPIKey: _yourGoogleAPIKey,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter your address',
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  maxLines: 1,
                  overlayContainer: (child) => Material(
                    elevation: 1.0,
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    child: child,
                  ),
                  getPlaceDetailWithLatLng: (prediction) {
                    if ((prediction.lat != null) && prediction.lng != null) {
                      selectedLocation = LatLng(
                        double.parse(prediction.lat!),
                        double.parse(prediction.lng!),
                      );
                      setState(() {});
                      myController.animateCamera(
                        CameraUpdate.newLatLng(selectedLocation!),
                      );
                    }
                  },
                  itmClick: (Prediction prediction) =>
                      _textController.text = prediction.description!,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: () async {
                await goToCurrentLocation();
              },
              child: const Icon(
                Icons.my_location_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }
}
