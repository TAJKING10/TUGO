import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as taj;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  late Location _location;
  bool _serviceEnabled = false;
  PermissionStatus? _grantedPermission;
  LocationService() {
    _location = Location();
  }

  Future<bool> _checkPermission() async {
    if (await _checkService()) {
      _grantedPermission = await _location.hasPermission();
      if (_grantedPermission == PermissionStatus.denied) {
        _grantedPermission = await _location.requestPermission();
      }
    }
    return _grantedPermission == PermissionStatus.granted;
  }

  Future<bool> _checkService() async {
    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
      }
    } on PlatformException catch (error) {
      print(
          'error code is ${error.code} and message =${error.message} )');
      _serviceEnabled = false;
      await _checkService();
    }
    return _serviceEnabled;
  }

  Future<LocationData?> getLocation() async {
    if (await _checkPermission()) {
      final locationData = _location.getLocation();
      return locationData;
    }
    return null;
  }

  Future<taj.Placemark?> getPlaceMark(
      {required LocationData locationData}) async {
    final List<taj.Placemark>? placeMarks = await taj.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);
    if (placeMarks != null && placeMarks.isNotEmpty) {
      return placeMarks[0];
    }
    return null;
  }
}

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  String? global_lat;
  String? global_long;
  String? global_country;
  String? global_adminArea;
  String? global_district;
  String? global_adress;
  String? global_postalcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Initial map center
          zoom: 11.0, // Initial map zoom
        ),
        markers: {
          Marker(
            markerId: MarkerId('user_location'),
            position: LatLng(double.parse(global_lat ?? '0'), double.parse(global_long ?? '0')),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    getLocation();
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);
      setState(() {
        global_lat = locationData.latitude!.toStringAsFixed(2);
        global_long = locationData.longitude!.toStringAsFixed(2);
        global_country = placeMark?.country ?? ' could not get country';
        global_adminArea = placeMark?.administrativeArea ?? ' could not get admin area';
        global_district = placeMark?.subAdministrativeArea ?? 'no';
        global_adress = placeMark?.street ?? 'could not find street';
        global_postalcode = placeMark?.postalCode ?? 'could not get admin postal code ';
      });

      // Move camera to user's location
      mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(locationData.latitude!, locationData.longitude!),
      ));
    }
  }
}
