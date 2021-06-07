import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwafer/Offers/data_base/product_database.dart';
import '../../HomePage.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  Color iconcolor = Colors.blueGrey;
  List<String> selectedproducts = [];
  bool tosearch = false;
  TextStyle textStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  Icon Iconsearch = Icon(Icons.search, color: Colors.blueGrey);
  Icon Iconclose = Icon(Icons.close, color: Colors.blueGrey);
  Widget Titletext =
      Text("All products", style: TextStyle(color: Colors.blueGrey));
  bool loading = false;
  bool allselected = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  // ignore: must_call_super
  void initState() {
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 10;
        print(controller.offset);
      });
    });
/*
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar( SnackBar(content: Text("priceUpdated".tr,textAlign: TextAlign.center,),
      backgroundColor: Colors.red.shade800,)));*/
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: width,
                alignment: Alignment.topCenter,
                height: closeTopContainer ? 0 : 350,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: ListTile(
                          title: Text(
                            "عروض و تخفيضات",
                            style: GoogleFonts.athiti(
                                color: Colors.red[900],
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            "قبل ما تشتري تصفح مئات الكوبونات من مواقع الانترنت ووفر ",
                            style: GoogleFonts.athiti(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage()));
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.red,
                                    size: 50,
                                  )),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Image.asset(
                        "assets/offercart.png",
                        height: 140,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Titlesearch(),
                    ),
                  ],
                ),
              ),
              loading
                  ? CircularProgressIndicator()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder<List<DocumentSnapshot>>(
                        future: ProductDatabase().getallproducts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(80.0),
                                  child: Text("The list is empty"),
                                ),
                              );
                            } else if (snapshot.hasData)

                              return ListView.builder(
                                  //shrinkWrap: true,
                           //     primary:true,
                                  physics:const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) ,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context,index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Card(
                                          elevation: 18.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          child: Image.network(
                                            snapshot.data[index]["images url"][0],
                                            fit: BoxFit.contain,
                                            height: 200.0,
                                            width: 130.0,
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          margin: EdgeInsets.all(8.0),
                                        ),
                                        Text(
                                          snapshot.data[index]["name"],
                                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    );
                                  });


                              // return ListView.builder(
                              //   controller: controller,
                              //   itemBuilder: ((context, index) {
                              //     return Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: InkWell(
                              //         onTap: () {
                              //           launchURL(
                              //               snapshot.data[index]["price"]);
                              //           print(snapshot.data[index]["price"]);
                              //         },
                              //         child: Card(
                              //           shape: RoundedRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(25)),
                              //           elevation: 15,
                              //           child: Container(
                              //             width: width * 0.9,
                              //             height: height * 0.25,
                              //             alignment: Alignment.center,
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(40),
                              //                 image: DecorationImage(
                              //                   image:  NetworkImage(
                              //                     snapshot.data[index]
                              //                     ["images url"][0],
                              //
                              //                   ),  fit: BoxFit.fitHeight,
                              //                 )),
                              //             child: Padding(
                              //               padding: EdgeInsets.all(20.0),
                              //               child: Column(
                              //                 children: [
                              //                   Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .spaceBetween,
                              //                     children: [
                              //                       Container(
                              //                         decoration: BoxDecoration(
                              //                           color: Colors.black,
                              //                           borderRadius:
                              //                               BorderRadius
                              //                                   .circular(20),
                              //                         ),
                              //                         height: height * 0.08,
                              //                         width: width * 0.8,
                              //                         child: Center(
                              //                           child: Image.network(
                              //                             snapshot.data[index]
                              //                                 ["images url"][0],
                              //                             fit: BoxFit.fill,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   SizedBox(
                              //                     height: height * 0.03,
                              //                   ),
                              //                   Text(
                              //                     snapshot.data[index]["name"],
                              //                     style: TextStyle(
                              //                       fontWeight: FontWeight.bold,
                              //                       fontSize: 30,
                              //                     ),
                              //                   ),
                              //                   SizedBox(
                              //                     height: height * 0.01,
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   }),
                              //   itemCount: snapshot.data.length,
                              // );
                          } else if (snapshot.hasError) {
                            return Center(
                              child:
                                  Text("Error    " + snapshot.error.toString()),
                            );
                          }
                          return Center(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  //*******************************************************************
  // start select all
  _selectall(bool selectall) {
    if (selectall) {
      ProductDatabase().getallproducts().then((value) {
        for (int i = 0; i < value.length; i++) {
          setState(() {
            selectedproducts.add(value[i].documentID);
            allselected = true;
          });
        }
      });
    } else {
      setState(() {
        selectedproducts.clear();
        allselected = false;
      });
    }
  }
  // end select all
  //********************************************************************
  // start change cat and change brand

  // end change cat and change brand
  //*************************************************************
  // start get elements
  Future<List<String>> _getelements(
      String col_name, String snap_elements) async {
    QuerySnapshot querytSnapshot =
        await Firestore.instance.collection(col_name).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querytSnapshot.documents;
    List<String> list = [];
    for (int i = 0; i < documentSnapshot.length; i++) {
      list.add(documentSnapshot[i][snap_elements]);
    }
    list.add("All");
    return list;
  }

  // end get elements
  //*************************************************************
  // start make menu
  List<PopupMenuEntry> menu(
      {DocumentSnapshot documentSnapshot = null,
      AsyncSnapshot<List<DocumentSnapshot>> snapshot = null,
      int index = null}) {
    List<PopupMenuEntry> list = [
      PopupMenuItem(
        value: index == null
            ? documentSnapshot["name"]
            : snapshot.data[index]["name"],
        child: Row(
          children: [
            FlatButton.icon(
              icon: Icon(Icons.edit),
              label: Text("Edit"),
              onPressed: () {
                /*  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    EditProduct(index == null ? documentSnapshot:snapshot.data[index]))
                );*/
              },
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: index == null
            ? documentSnapshot["name"]
            : snapshot.data[index]["name"],
        child: Row(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              onPressed: () {
                selectedproducts.add(index == null
                    ? documentSnapshot.documentID
                    : snapshot.data[index].documentID);
                _confirmdelete();
              },
            )
          ],
        ),
      )
    ];
    return list;
  }

  // end make menu
  //*************************************************************
  // start build title search
  Widget Titlesearch() {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
            hintText: "Search ",
            icon: Icon(
              Icons.search,
              color: Colors.red[900],
            ),
            hintStyle: TextStyle(color: Colors.red[900])),
        autofocus: false,
      ),
      suggestionsCallback: (pattern) async {
        return await ProductDatabase().getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(
            Icons.shopping_cart,
            color: Colors.red,
          ),
          title: Text(suggestion['name']),
          subtitle: Text('\$${suggestion['price']}'),
        );
      },
      onSuggestionSelected: (suggestion) {
        showMenu(
            position: RelativeRect.fromLTRB(200, 20, 200, 200),
            context: context,
            items: menu(documentSnapshot: suggestion));
      },
    );
  }

  // end build title search
  //*****************************************************************
  // start confirm delete
  Future<void> _confirmdelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warnning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you want to delete selectesd products'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          onPressed: () {
                            _deleteproduct(selectedproducts);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Not now',
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteproduct(List<String> products) {
    if (products.isNotEmpty) {
      setState(() {
        ProductDatabase().deleteproducts(products);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Offers()));
      });
    } else {
      Fluttertoast.showToast(msg: "please select product to delete");
    }
  }

  // end confirm delete
  //*******************************************************************
  // start change check
  void changcheck(bool val, String PRODUCT_ID,
      AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    if (val) {
      setState(() {
        selectedproducts.add(PRODUCT_ID);
      });
    } else {
      setState(() {
        selectedproducts.remove(PRODUCT_ID);
      });
    }

    if (snapshot.data.length != selectedproducts.length) {
      setState(() {
        allselected = false;
      });
    } else {
      allselected = true;
    }
  }
// end change check
}
