import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> _getLocationAndMakeRequest() async {
    print('btn ');
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    print('Latitude ${position.latitude} Longitude ${position.longitude}');
    
  final uri = Uri.https('jsonplaceholder.typicode.com', '/get/?lat=${position.latitude}&lon=${position.longitude}');
      // Make GET request with latitude and longitude
      final response = await http.get(
        uri,
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('API Response: ${response.body}');
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle location or network errors
      print('Error: $e');
    }
  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location API Demo'),
        ),
        body: Center(
          child: Center(
            child: ElevatedButton(  
              child: const Text("Press..."),
              onPressed: ()async{
                await _LocationButtonState;
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocationButton extends StatefulWidget {
  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  Future<void> _getLocationAndMakeRequest() async {
    print('btn ');
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    print('Latitude ${position.latitude} Longitude ${position.longitude}');
    
  final uri = Uri.https('jsonplaceholder.typicode.com', '/get/?lat=${position.latitude}&lon=${position.longitude}');
      // Make GET request with latitude and longitude
      final response = await http.get(
        uri,
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('API Response: ${response.body}');
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle location or network errors
      print('Error: $e');
    }
  }
  @override
  void initState() async {
    // TODO: implement initState
    super.initState(); 
    LocationPermission permission =await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _getLocationAndMakeRequest;
      },
      child: Text('Get Location and Make Request'),
    );
  }
}
