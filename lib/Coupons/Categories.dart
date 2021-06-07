import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwafer/Offers/data_base/category_database.dart';

import '../HomePage.dart';
import 'CategoryProducts.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Firestore _firestore = Firestore.instance;
  CATDatabse _dataBase = CATDatabse();
  ScrollController controller = ScrollController();
  ScrollController controller2 = ScrollController();
  bool loading = false;
  bool closeTopContainer = false;
  CATDatabse _databse = CATDatabse();
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

  bool allselected = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final key = GlobalKey();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 50;
        print(controller.offset);
      });
    });
    controller2.addListener(() {
      setState(() {
        closeTopContainer = true;
        print(controller.offset);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
        //  height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
              width: width,
              height: closeTopContainer ? 0 : 300,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: ListTile(
                          title: Text(
                            "كوبونات الخصم",
                            style: GoogleFonts.athiti(
                                color: Colors.red[900],
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            "كل كوبونات المتاجر و المواقع لدينا مجمعة لك في تطبيق واحد",
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
                                            builder: (context) => HomePage()));
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
                        "assets/couCartoon.png",
                        height: 110,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TypeAheadField(
                        hideSuggestionsOnKeyboardHide: false,
                        keepSuggestionsOnLoading: false,
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
                          return await _dataBase.getSuggestions(pattern);
                        },
                        itemBuilder: (context, DocumentSnapshot suggestion) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            child: ListView.builder(
                                controller: controller2,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return MyCard(
                                    img: suggestion['imgurl'],
                                    txt: suggestion['category'],
                                    catDes: suggestion['catdes'],
                                    categorie: suggestion['categorie'],
                                    docId: suggestion.documentID,
                                  );
                                }),
                          );
                          /*ListTile(
          title: Row(
            children:
            [
              Image.network(suggestion['imgurl'],width: 40,height: 40,),
            ],
          ),
          trailing: Text(suggestion['category']),
        );*/
                        },
                        onSuggestionSelected: (suggestion) async {
                          if (suggestion == null) {
                            _dataBase.getAllCAT();
                          } else {
                            String id = "";
                            QuerySnapshot querytSnapshot = await _firestore
                                .collection('categories')
                                .where("category",
                                    isEqualTo: suggestion['category'])
                                .getDocuments();
                            DocumentSnapshot snapshot =
                                querytSnapshot.documents[5];
                            id = snapshot.documentID;
                            print(suggestion);
                            print(id);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryProduct(
                                          id.toString(),
                                          suggestion["category"],
                                          suggestion["catDes"],
                                        )));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      SizedBox(
                        height: height * 100,
                        child: FutureBuilder<List<DocumentSnapshot>>(
                            future: _databse.getAllCAT(),
                            builder: (context, data) {
                              if (data.hasError) {
                                return Center(
                                  child: Text(
                                      "Error at   ${data.error.toString()}"),
                                );
                              } else if (data.hasData) {
                                return ListView.builder(
                                  key: key,
                                  itemCount: data.data.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: controller,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MyCard(
                                        img: data.data[index]["imgurl"],
                                        txt: data.data[index]["category"],
                                        docId: data.data[index].documentID,
                                        categorie: data.data[index]["category"],
                                        catDes: data.data[index]["catDes"],
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ));
  }
}

class MyCard extends StatefulWidget {
  final String img;
  final String txt;
  final docId;
  final categorie;
  final catDes;

  const MyCard(
      {Key key, this.img, this.txt, this.docId, this.categorie, this.catDes})
      : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  String CATID = "All";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Container(

          width: width * 0.8,
          height: height * 0.4,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage("assets/card.png"),fit: BoxFit.cover
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20,top: 20),
                      decoration: BoxDecoration(
                        color: Color(0xff00eba7),
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      width: 150,
                      child: Center(
                        child: Text(
                          'إنسخ الكود',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xfffceb00),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                      ),
                      height:  MediaQuery.of(context).size.width/3,
                       width: MediaQuery.of(context).size.width/3,
                      child: Flexible(

                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                          child: Image.network(
                            widget.img,
                            fit:BoxFit.cover ,
                            //  data.data[index]["imgurl"],
                            // width: 50,
                            // height: 130,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: height * 0.03,
              // ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.txt,
                  textAlign: TextAlign.center,
                  // data.data[index]["category"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.04,
                  ),
                ),
              ),

              Expanded(
                // width: width * 0.8,
                // height: height * 0.05,
flex: 1,

                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // ignore: unnecessary_statements

                      CATID = widget.docId;
                      //data.data[index].documentID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryProduct(
                                CATID,
                                widget.categorie,
                                widget.catDes,
                                //data.data[index]["category"],
                                //data.data[index]["catDes"],
                              )));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "تسوق الان".toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  style: ButtonStyle(
                      // padding: MaterialStateProperty.all<EdgeInsets>(
                      //     EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff00eba7).withOpacity(0.5)),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              ))),
                ),

                //
                // child: ElevatedButton(
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(Colors.red),
                //     ),
                //     onPressed: () {
                //       setState(() {
                //         // ignore: unnecessary_statements
                //
                //         CATID = widget.docId;
                //         //data.data[index].documentID;
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => CategoryProduct(
                //                       CATID,
                //                       widget.categorie,
                //                       widget.catDes,
                //                       //data.data[index]["category"],
                //                       //data.data[index]["catDes"],
                //                     )));
                //       });
                //     },
                //     child: Text(
                //       'تسوق الان ',
                //       style: TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.bold),
                //     )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
