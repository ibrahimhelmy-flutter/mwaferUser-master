import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Coupons/Categories.dart';
import 'Offers/pages/all_products_page_EID.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: Cuvedshape(),
        title: Text("وفر قريشاتك",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.red[900],
          onPressed: () {},
        ),
        elevation: 10,
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Categories()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.31,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/intro3.png",
                              width: 200,
                            ),
                            Text(
                              "كوبونات خصم",
                              style: GoogleFonts.athiti(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Offers()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.31,
                    width: MediaQuery.of(context).size.width * 0.91,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/intro2.png",
                              width: 200,
                            ),
                            Text(
                              "العروض",
                              style: GoogleFonts.athiti(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cuvedshape extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(rect.size.width / 2, rect.size.height + 35 * 2,
        rect.size.width, rect.size.height)
    ..lineTo(rect.size.width, 0)
    ..close();
}
