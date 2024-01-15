import 'package:flutter/material.dart';


Widget myBody(BuildContext context){return Column(
  children: [
    Text('${fetching}'),
    
    ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPage()));
      },
      child: Text('GO TO LOCATION'),
    ),

    Container(
      decoration: BoxDecoration(color: Colors.green),
      child: fetching
          ? Center(child: CircularProgressIndicator())
          : Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Handle item tap
                      },
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height / 4,
                              width: size.width / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network("https://avatars.githubusercontent.com/u/50028081?v=4", fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: size.width / 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Name: Aarav Paudel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                Text("Price: 10000", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                Text("Shop: Kawasoti Mobile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                                Text("Offer Price: Rs.800", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    ),
  ],
);
}
