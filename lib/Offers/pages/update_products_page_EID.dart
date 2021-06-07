import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mwafer/Offers/data_base/product_database.dart';

import 'add_products_page_EID.dart';

class EditProduct extends StatefulWidget
{
  DocumentSnapshot _documentSnapshot;
  EditProduct(this._documentSnapshot);
  @override
  _EditProductState createState() => _EditProductState(_documentSnapshot);
}

class _EditProductState extends State<EditProduct>
{
  DocumentSnapshot _documentSnapshot;
  _EditProductState(this._documentSnapshot);
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  List<String> imgsurl = [];
  List<String> selectedColors = [];
  File image1;
  bool loading = false;
  String productname="";
  String description="";
  String price="";

  @override
  void initState()
  {
    super.initState();

    for(int i=0;i<_documentSnapshot["images url"].length;i++)
    {
      imgsurl.add(_documentSnapshot["images url"][i]);
    }

    productname=_documentSnapshot["name"];
    description=_documentSnapshot["description"];
    price=_documentSnapshot["price"];


  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Edit product",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [
            Row(
              children:
              [
                _Custombutton(1, imgsurl[0]),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                initialValue: productname,
                decoration: InputDecoration(
                  hintText: "The name must be less than 10 letters",
                  labelText: "Product name",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                validator: (val) {
                  if (val.isEmpty || val.length > 10) {
                    return "Product name must be less than 10 letters";
                  }
                  else{
                    setState(() {
                    productname=val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
              child: TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: "description",
                  hintText: "provide breif details about the ptoduct",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                maxLines: 2,
                maxLength: 100,
                validator: (val) {
                  if (val.isEmpty || val.length > 100) {
                    return "description  must have data";
                  }
                  else{
                    setState(() {
                    description=val;
                    });
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextFormField(
                        initialValue: price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: "L.E",
                          labelText: "Price",
                          labelStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Enter Valid price";
                          }
                          else{
                            setState(() {
                              price=val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: ()
                      {
                        _editproduct();
                      },
                      child: Text("Edit product"),
                      color: Colors.orange,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //***********************************************************
  // start custom button
  Widget _Custombutton(int imagnum, String imageurl)
  {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
            onPressed: ()
            {
              (_pickimage(imagnum));
            },
            child: imageurl == null ? Padding(padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
              child: Text("No available image"),) : Container(
              height: 120,
              child: Stack(
                children:
                [
                  Image.network(
                    imageurl,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    height: 120,
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text("edit",style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  _pickimage(int imgnum) async
  {
    File tempimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    switch (imgnum)
    {
      case 1:
        setState(() {
          image1 = tempimage;
        });
        break;

    }
  }
  // end custom button
  //***********************************************************
  // start get elements
  Future<List<String>> _getelements(String col_name, String snap_elements) async
  {
    QuerySnapshot querytSnapshot = await Firestore.instance.collection(col_name).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querytSnapshot.documents;
    List<String> list = [];
    for (int i = 0; i < documentSnapshot.length; i++)
    {
      list.add(documentSnapshot[i][snap_elements]);
    }
    return list;
  }
  // end get elements
  void _editproduct()
  {
    if (_formkey.currentState.validate() &&

        productname.isNotEmpty&&
        description.isNotEmpty&&
        price.isNotEmpty&&
        selectedColors.isNotEmpty)
    {
      setState(() {
        loading = false;
      });
      ProductDatabase().updateProduct(
          _documentSnapshot.documentID,
          productname,
          description,

          price,
          imgsurl,
          );
      Fluttertoast.showToast(msg: "product Edited");

    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }
  // end edit product
}
