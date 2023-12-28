import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/fetures/app/data/models/place_location_model.dart';
import 'package:flutter_favorite_places/fetures/app/presentation/pages/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String keyApi = 'AIzaSyD2dI6oaWkmWEVgx9O6KZyRYtB3rHLMBLk';
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //TODO : Save location
  Future<void> _savePlace(double latitude, double longitude) async {
    //นำข้อมูล lat, lon มาหาชื่อที่อยู่ใน api
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$keyApi');

    final response = await http.get(url);
    log('response: $response');
    final resData = json.decode(response.body);
    log('resData: $resData');
    final address = resData['results'][0]['formatted_address'];

    log('address: $address');

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
    log('pick: $_pickedLocation');
  }

  //TODO : Function Get Location (lat, lon)
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    //ส่งคำขออนุญาติ
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //รอการอนุมัติ gps จาก user
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    //ข้อมูลที่อยู่ที่ได้
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;
    log('lat: $lat');
    log('lon: $lon');

    if (lat == null || lon == null) return;
    _savePlace(lat, lon);
  }

  //TODO : Get ImageURL from Location (Lat,Lon) หน้าตาเหมือน google map
  String get locationImage {
    log('pick: $_pickedLocation');
    if (_pickedLocation == null) return '';

    final lat = _pickedLocation!.latitude;
    final lon = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=$keyApi';
  }

  //TODO : Select Map
  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) return;
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

//================================================================================================================
  @override
  Widget build(BuildContext context) {
    //TODO 1: Nothing
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    //TODO 2: Loading
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    //TODO 3: Data loading success
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    //TODO 4: Continer Content
    return Column(
      children: [
        //TODO 4.1: Continer location value
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),

        //TODO 4.2: Button Get Location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}
