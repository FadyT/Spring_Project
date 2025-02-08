import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;

  final LatLng _cairoLocation = LatLng(30.0444, 31.2357);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _cairoLocation,
          zoom: 12.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId("cairo_marker"),
            position: _cairoLocation,
            infoWindow: InfoWindow(title: "Cairo, Egypt"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoogleMapScreen(),
  ));
}
