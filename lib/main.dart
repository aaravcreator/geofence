// main.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofence/pages/locationPage.dart';
import 'package:geofence/utils/sharedprefs.dart';
import 'package:http/http.dart' as http;

import '/models/product_model.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late List<Product> products = [];
  var fetching = false;

  @override
  void initState() {
    super.initState();
    testing();
    fetchData();
  }

  void testing() {
    print('test');
  }

  Future<void> fetchData() async {
    print('fetching');
    Uri url = Uri.http('192.168.1.67:8000', '/products/');
    fetching = true;
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successful response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
        });
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
      }
      fetching = false;
      print(products.length);
      setState(() {});
    } catch (e) {
      print('Error in fetch ${e}');
    } finally {
      fetching = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Column(
        children: [
          Text('${fetching}'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LocationPage()));
            },
            child: Text('GO TO LOCATION'),
          ),
          fetching
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ))
              : Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
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
                                    child: product.name == "Widget A" ? Image.asset('assets/images/product-placeholder.png'): Image.network(
                                        "https://avatars.githubusercontent.com/u/50028081?v=4",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildTitle(products[index].name),
                                      Text("${products[index].name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text("Price: ${products[index].markedPrice}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text("Shop: Kawasoti Mobile",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text("Offer Price: Rs.800",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
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
      ),
    );
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

}
