import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool isLoading = false;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      _currentLocation = LatLng(widget.latitude, widget.longitude);
    });

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation!,
          zoom: 16.0,
        ),
      ),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation!.latitude, _currentLocation!.longitude);
    Placemark address = placemarks[0];

    setState(() {
      isLoading = false;
      _markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: _currentLocation!,
        infoWindow: InfoWindow(title: "Lokasi Antar", snippet: address.street),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Topbar(
            title: 'Peta',
            leading: const MyBackButton(),
            action: IconButton(
                onPressed: () {
                  _openGoogleMaps();
                },
                icon: const Icon(
                  Icons.directions,
                  color: Colors.white,
                )),
          ),
          Expanded(
              child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            zoomControlsEnabled: false,
            markers: _markers,
            onMapCreated: (controller) {
              _onMapCreated(controller);
            },
          ))
        ],
      ),
    );
  }

  void _openGoogleMaps() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}&travelmode=driving';
    // if (await canLaunch(url)) {
    await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not open Google Maps.';
    // }
  }
}
