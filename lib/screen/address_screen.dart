import 'package:flutter/material.dart';
import 'package:food_order_app/repository/user_repository.dart';
import 'package:food_order_app/util/color.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController _searchLocation = TextEditingController();

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission locationPermission = await Geolocator.checkPermission();
      if(locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever){
        print('Permission denied');
        LocationPermission ask = await Geolocator.requestPermission();
      } else{
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          print('${placemark.street} ${placemark.subThoroughfare ?? ""}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}');
          await UserRepository().updateAddress('${placemark.street}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}');
        }
      }

    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(
              Icons.my_location,
              color: ThemeBgColor,
            ),
            label: Text(
              'Search for location',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
            ),
          ),
          controller: _searchLocation,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: ThemeBgColor,
                ),
                title: const Text('Using your current location'),
                onTap: () async {
                  await _getCurrentLocation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
