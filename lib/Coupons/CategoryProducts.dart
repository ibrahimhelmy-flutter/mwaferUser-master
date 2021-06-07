import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mwafer/Offers/data_base/category_database.dart';
import 'package:mwafer/Offers/data_base/coupon_database.dart';

class CategoryProduct extends StatefulWidget {
  ProductDatabase _productDatabase = ProductDatabase();
  String CATID, CatName, catDes;
  CategoryProduct(String id, String CatName, String catDes) {
    this.CATID = id;
    this.catDes = catDes;
    this.CatName = CatName;
  }
  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.CatName,
            style: GoogleFonts.lobster(
              fontSize: 26,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[900],
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo.jpg"),
                  fit: BoxFit.fitWidth,
                  colorFilter: new ColorFilter.mode(
                      Colors.grey.withOpacity(0.6), BlendMode.dstATop),
                ),
              ),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    widget.CatName,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.athiti(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  widget.catDes,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.athiti(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 500,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: widget._productDatabase.getallproducts(widget.CATID),
                builder: (context, data) {
                  if (data.hasData) {
                    if (data.data.isNotEmpty) {
                      return GridView.builder(
                          itemCount: data.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 0.7),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductItem(data.data[index]);
                          });
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: Text(
                            "No product for that category yet",
                            style: GoogleFonts.athiti(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      );
                    }
                  } else if (data.hasError) {
                    return Center(
                      child: Text("Error at ${data.error.toString()}"),
                    );
                  }
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

//******************************************************************************
// class of product Item
class ProductItem extends StatelessWidget {
  CATDatabse _CATDatabase = CATDatabse();

  final DocumentSnapshot _documentSnapshot;
  ProductItem(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            _documentSnapshot['name'],
            style: GoogleFonts.athiti(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _documentSnapshot['description'],
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.athiti(
                fontSize: 15,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () {
                FlutterClipboard.copy(_documentSnapshot['price']);
                Fluttertoast.showToast(
                    msg: "تم النسخ",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[900],
                    textColor: Colors.white,
                    fontSize: 16.0);
                // var snackBar = SnackBar(content: Text('تم النسخ'));
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text(
                "نسخ الكود",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
    /*InkWell(
      onTap: ()
      {
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 4),
        child: Column(
          children: [
            */ /* Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _documentSnapshot['name'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),*/ /*
            ConstrainedBox(
                constraints: new BoxConstraints(
                  maxHeight:200,
                  maxWidth: 120,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(5, 7), // changes position of shadow
                            ),
                          ],
                          color: Colors.white70),
                    ),
                    Positioned(
                      bottom: 28,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.withOpacity(.7)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _documentSnapshot['name'].toString(),
                            style: TextStyle(
                                color: Colors.black.withOpacity(.8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Soleil"),
                          ),
                        ),
                      ),
                    ),
                     Positioned(
                        top: 5,
                        left: 2,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .75,

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: _CATDatabase.getCAT(_documentSnapshot["category"],),
                                  builder: (context, snapshot)
                                  {
                                    if (snapshot.hasData)
                                    {
                                      return ListTile(
                                        title: Text(snapshot.data["category"],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.athiti(
                                            color: Colors.white,
                                            fontSize: 17,shadows: [Shadow(
                                              blurRadius: 10,
                                          )],
                                            fontWeight: FontWeight.w700,
                                          ),),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error please try later");
                                    }
                                    return Text("loading ....");
                                  },
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                )


            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width-150 ,
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );*/
  }
}
