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
        backgroundColor: Color(0xffeeeeee),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(

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
                Center(
                //  padding: const EdgeInsets.only(left: 20.0),
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
                      return       MyCard(
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
                                builder: (context) => CategoryProduct(
                                      id.toString(),
                                      suggestion["category"],
                                      suggestion["catDes"],
                                    )));
                      }
                    },
                  ),
                ),
                loading
                    ? Center(child: CircularProgressIndicator())
                    :
                Container(
                  height: 2400,
                  child: FutureBuilder<List<DocumentSnapshot>>(
                      future: _databse.getAllCAT(),
                      builder: (context, data) {
                        if (data.hasError) {
                          return Center(
                            child: Text("Error at   ${data.error.toString()}"),
                          );
                        } else if (data.hasData) {
                          return ListView.builder(
                            key: key,
                            itemCount: data.data.length,
                               physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            itemBuilder: (context, index) {
                              return MyCard(
                                img: data.data[index]["imgurl"],
                                txt: data.data[index]["category"],
                                docId: data.data[index].documentID,
                                categorie: data.data[index]["category"],
                                catDes: data.data[index]["catDes"],
                              );
                            },
                          );
                        }
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }),
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

    return Container(
     height: height / 2.7,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: Text("أنسخ الكود",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                  SizedBox(width: width/6),
                  Container(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
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
          Expanded(flex: 5, child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Text(
                  widget.txt,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize:22,
                  )),

              Text(
                              widget.catDes,
                              textAlign: TextAlign.end,
maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize:18,
                              ))
            ],),
          )),
          Expanded(flex: 3,child:
           InkWell(
            onTap: () {
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
            child: new Container(
              margin: const EdgeInsets.only(bottom: 5),
              width: width/1.2,
              height: 55.0,
              decoration: new BoxDecoration(
                color: Colors.blueAccent,
                border: new Border.all(color: Colors.white, width: 2.0),
                borderRadius: new BorderRadius.circular(7.0),
              ),
              child: new Center(child: new Text('تسوق الان', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
            ),
          ),


          )
        ],
      ),
    );

  }
}
