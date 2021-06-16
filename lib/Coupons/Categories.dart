import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mwafer/Offers/data_base/category_database.dart';
import 'package:mwafer/widget/animatedbutton.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double numberc=1;
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
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    var padding=              Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadField(
        hideSuggestionsOnKeyboardHide: false,
        keepSuggestionsOnLoading: false,
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.greenAccent, width: 1.0),
                  borderRadius: BorderRadius.circular(15)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.greenAccent, width: 1.0),
                  borderRadius: BorderRadius.circular(15)),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xff02ab94).withOpacity(0.5),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Search ",
              hintStyle: TextStyle(
                  color: Color(0xff02ab94).withOpacity(0.5))),
          autofocus: false,
        ),
        suggestionsCallback: (pattern) async {
          return await _dataBase.getSuggestions(pattern);
        },
        itemBuilder: (context, DocumentSnapshot suggestion) {
          return MyCard(
            img: suggestion['imgurl'],
            txt: suggestion['category'],
            catDes: suggestion['catDes'],
            categorie: suggestion['category'],
            docId: suggestion.documentID,
          );

          // title: Row(
          // children:
          // [
          //   Image.network(suggestion['imgurl'],width: 40,height: 40,),
          // ],
          // ),
          // trailing: Text(suggestion['category']),
          // );
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
            DocumentSnapshot snapshot = querytSnapshot.documents[5];
            id = snapshot.documentID;
            print(suggestion);
            print(id);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryProduct(
                          id.toString(),
                          suggestion["category"],
                          suggestion["catDes"],
                        )));
          }
        },
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffeeeeee),
          title: Text(
            "كوبونات الخصم",
            style: GoogleFonts.athiti(
                color: Color(0xff02ab94),
                fontSize: 26,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xff02ab94),
                size: 50,
              )),
        ),
        backgroundColor: Color(0xffeeeeee),
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.all(12),
              //
              //   child: Stack(
              //
              //     children: [
              //
              //       Container(
              //
              //         child: ListTile(
              //             title: Text(
              //               "كوبونات الخصم",
              //               style: GoogleFonts.athiti(
              //                   color: Colors.red[900],
              //                   fontSize: 26,
              //                   fontWeight: FontWeight.bold),
              //               textAlign: TextAlign.right,
              //             ),
              //
              //             leading: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 IconButton(
              //                     onPressed: () {
              //                       Navigator.pushReplacement(
              //                           context,
              //                           MaterialPageRoute(
              //                               builder: (context) => HomePage()));
              //                     },
              //                     icon: Icon(
              //                       Icons.arrow_back_rounded,
              //                       color: Color(0xff02ab94),
              //                       size: 50,
              //                     )),
              //               ],
              //             )),
              //       )
              //
              //     ],
              //
              //
              //   ),
              // ),
              padding,

              loading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Container(
             height: MediaQuery.of(context).size.height-170,
                      child: FutureBuilder<List<DocumentSnapshot>>(
                          future: _databse.getAllCAT(),
                          builder: (context, data) {
                            if (data.hasError) {
                              return Center(
                                child: Text(
                                    "Error at   ${data.error.toString()}"),
                              );
                            } else if (data.hasData) {
                            //  setState(() {
                                 numberc=double.parse(data.data.length.toString());
                           //   });
                              return ListView.builder(
                                key: key,
                                itemCount: data.data.length,
                            //  physics:PageScrollPhysics(),
                                controller: controller,
                                itemBuilder: (context, index) {
                                  return MyCard(
                                      img: data.data[index]["imgurl"],
                                      txt: data.data[index]["category"],
                                      docId: data.data[index].documentID,
                                      categorie: data.data[index]["category"],
                                      catDes: data.data[index]["catDes"],
                                      copUrl: data.data[index]["copUrl"]
                                  );
                                },
                              );
                            }
                            return Container(
                                child: Center(
                                    child: CircularProgressIndicator()));
                          }),
                    ),
                  ),
            ],
          ),
        ));
  }
}

class MyCard extends StatefulWidget {
  final String img;
  final String txt;
  final String copUrl;
  final docId;
  final categorie;
  final catDes;

  const MyCard(
      {Key key, this.img, this.txt, this.docId, this.categorie, this.catDes, this.copUrl})
      : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  //String CATID = "All";
  String code="";

  Future<String> getCode()async{
    QuerySnapshot querytSnapshot = await Firestore
        .instance
        .collection('coupons')
        .where("category",
        isEqualTo: widget.docId)
        .getDocuments();
    DocumentSnapshot snapshot = querytSnapshot
        .documents[0];
 setState(() {
   code = snapshot['price'];
 });
    return code;
  }

  @override
  Widget build(BuildContext context) {
    getCode();
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;




    return Container(
      height: height / 3.4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //  width:width/2,
                    height: 40,
                    padding: EdgeInsets.only(left: 5),
                    child: AnimatedButton(
                      initialText: "انسخ الكود ",
                      onTap: () {
                        setState(() async {


                          FlutterClipboard.copy(code);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(code.isNotEmpty?"تم نسخ الكود ":"لا يوجد كود"),
                            duration: Duration(seconds: 1),));
                        });
                      },
                      animationDuration: Duration(seconds: 1),
                      finalText
                      :code,
                      iconData: Icons.done,
                      iconSize: 20,
                      buttonStyle: mButtonStyle(borderRadius: 0.0,
                          elevation: 0.0,
                          primaryColor: Color(0xff02ab94),
                          secondaryColor: Colors.white,
                          finalTextStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // TextButton(onPressed: () {}, child: Text("أنسخ الكود",style: TextStyle(fontSize: 20,color: Color(0xff02ab94),fontWeight: FontWeight.bold),)),
                  SizedBox(width: 5),
                  Container(
                    width: 150,
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.only(topRight: Radius.circular(7)),
                      child: Image.network(
                        widget.img,
                        fit: BoxFit.fill,
                        //  data.data[index]["imgurl"],
                        // width: 50,
                        // height: 130,
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: Colors.green),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.txt,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        )),
                    Text(widget.catDes,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ))
                  ],
                ),
              )),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() async {
                  var canLaunch2 = await canLaunch(widget.copUrl);
                  canLaunch2 == true ? launch(widget.copUrl) : ScaffoldMessenger
                      .of(context).showSnackBar(SnackBar(
                    content: Text("الرابط غير صحيح "),
                    duration: Duration(seconds: 1),));
                });

                // setState(() {
                //   // ignore: unnecessary_statements
                //
                //   CATID = widget.docId;
                //   //data.data[index].documentID;
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => CategoryProduct(
                //                 CATID,
                //                 widget.categorie,
                //                 widget.catDes,
                //                 //data.data[index]["category"],
                //                 //data.data[index]["catDes"],
                //               )));
                // });
              },
              child: new Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: width / 1.3,
                decoration: new BoxDecoration(
                  color: Color(0xff02ab94),
                  borderRadius: new BorderRadius.circular(7.0),
                ),
                child: new Center(
                  child: new Text(
                    'تسوق الان',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
