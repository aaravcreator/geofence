import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geofence/models/offer_model.dart';
import 'package:geofence/utils/sharedprefs.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';






// class LocationPage extends StatelessWidget {
//   const LocationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('OFFERS PAGE'),),
//       body: LocationButton(),
      
//     );
//   }
// }
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  String? latitude;
  String? longitude;
  String? distance;
  Position? position;
  var fetching = false;
  List<Offer?> offers = [];



@override
  void initState() {
    super.initState();
    testserver();
  
  }


  Future<void> testserver() async {
       final host = Uri.http(sharedPrefs.ipAddress,'/ping/');
                  try{
                    var response = await  http.get(host);
                   if (response.statusCode == 200){
                    print(response.body);
                   
                   

                  
                   }
                  }
                  catch(e){
                    print("ERROR IN IP PING : ${e}");
                    
                    createIpAlert(context);
                  }
  }
  TextEditingController ipAddressController = TextEditingController();
  String? myIP = sharedPrefs.ipAddress;
  Future<void> _getLocationAndMakeRequest() async {
    setState(() {
      fetching = true;
    });
    // Firstly request Permission and then take other action
    LocationPermission permission =await Geolocator.requestPermission();
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Make GET request with latitude and longitude
      // offers/by-location/?latitude=26.797206&longitude=87.291943
      final url = Uri.http('${sharedPrefs.ipAddress}','/offers/by-location/' ,{'latitude':"${position?.latitude}",'longitude':"${position?.longitude}"});
      print(url);
      
      final response = await http.get(
        url
       ,
      );

      if (response.statusCode == 200) {

        final response_json = json.decode(response.body);
        List<dynamic> offers_list = response_json['offers'];

      
        setState(() {
          fetching = false;
           distance = "${response_json['shop_distance']}";
          offers  = offers_list.map((item) => Offer.fromJson(item)).toList();
        });
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
  setState(() {
    
    latitude = "${position?.latitude}";
    longitude = "${position?.longitude}";

  });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(appBar: AppBar(title: Text("Offers Page",),actions: [IconButton(onPressed: (){
      createIpAlert(context);
    }, icon: Icon(Icons.settings))],),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('LATITUDE : ${latitude} and LONGITUDE : ${longitude}'),
        ElevatedButton(
          onPressed: ()async{
            await _getLocationAndMakeRequest();
          },
          child: Text('Get Location and Fetch Offers'),
        ),
        fetching?CircularProgressIndicator():
        Expanded(
                  child: ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Handle item tap
                          },
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset: Offset(
                                      0, 3), // Offset in x and y direction
                                ),
                              ],
                            ),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height / 6,
                                  width: size.width / 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft: Radius.circular(10)),
                                    child: offer?.productImage == "Widget A" ? Image.asset('assets/images/product-placeholder.png'): Image.network(
                                        "http://${sharedPrefs.ipAddress}${offer?.productImage}",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildTitle(offer?.offerTitle),
                                      Text("Offer Price: ${offer?.offerPrice}",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text("Original Price: ${offer?.originalPrice}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text("Shop: ${offer?.shopName}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15)),
                                       Text("Shop Distance: ${distance??'N/A'} m",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                     
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ],
    ),);
  }

  Widget _buildTitle(String? title) {
  return Row(
    children: [
      const Icon(Icons.discount_outlined),
      const SizedBox(width: 8), // Add some space between icon and title
      Text(
        title ?? "Offer Offer", // Use the default value if title is null
        style: TextStyle(

          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 20
          // Add your desired text style here
        ),
      ),
    ],
  );
}



createIpAlert(BuildContext context) {
     TextEditingController ipcontroller =
        TextEditingController(text: sharedPrefs.ipAddress.toString());
    return showDialog(
        context: context,
        builder: (context) {
          var error = false;
          String error_data = '';
          String? current = sharedPrefs.ipAddress;
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
            scrollable: true,
            title: const Text("Update Host/IP address of server"),
            content: Column(
              children: [
               const Text("Host/IP address of server"),
                Text("Current - ${current}"),

                TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        hintText: 'Eg 192.168.1.67:8000'),
                    controller: ipcontroller),
                    error?Text('ERROR: $error_data',style: TextStyle(color:Colors.red),):SizedBox(height: 0,width: 0,)
                  
                    ,
                 
                   
              ],
            ),
            actions: [
              MaterialButton(
                color: Colors.red,
                child: const Text("OK"),
                onPressed: () async {
                  print(ipcontroller.text);
                  sharedPrefs.ipAddress = ipcontroller.text;
                  print(sharedPrefs.ipAddress);
                  if (sharedPrefs.ipAddress == '444'){

                  }
                  else{
                    final host = Uri.http(sharedPrefs.ipAddress,'/ping/');
                  try{
                    var response = await  http.get(host);
                   if (response.statusCode == 200){
                    print(response.body);
                    error= false;
                    error_data = "Success";
                    setState(() {
                      current = sharedPrefs.ipAddress;
                      
                    });

                     Navigator.of(context).pop();
                   }
                  }
                  catch(e){
                    print("ERROR IN IP PING : ${e}");
                    error= true;
                    error_data = 'Error connecting to server $e';
                  }
                   setState((){
                     current = sharedPrefs.ipAddress;
                   });
                  }
                  // sharedPrefs.brightness = int.parse(brightnessController.text);
                //  await dioService.checkDevice(ipcontroller.text);
                //   setState(() {
                //   myIP = sharedPrefs.ipAddress;
                //   });
                // TODO: Check the validity of the ip address by hitting a endpoint
                
                },
              ),
            ],
          );
          }
          );
        });
  }
}
