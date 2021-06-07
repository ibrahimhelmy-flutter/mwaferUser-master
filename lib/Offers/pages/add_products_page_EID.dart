import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mwafer/Offers/data_base/product_database.dart';

import 'all_products_page_EID.dart';
class AddProduct extends StatefulWidget
{
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct>
{
  TextEditingController _productcontroler = TextEditingController();
  TextEditingController _desccontroler =  TextEditingController();
  TextEditingController _pricecontroller =  TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<String> imgsurl = [];
  File image1 ;
  bool loading = false;
  String productname="";
  String description="";
  String price="";
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اضف عرض",

        ),
        backgroundColor: Colors.red.shade800,
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body:  loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [
            Row(
              children: <Widget>[
                _Custombutton(1, image1),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "اسم المعلن",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                controller: _productcontroler,
                validator: (val)
                {
                  if (val.isEmpty ) {
                    return "من فضلك ادخل اسم المعلن";
                  }
                  else{
                    setState(() {
                      productname = val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "وصف العرض",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintText: "وصف العرض",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                controller: _desccontroler,
                validator: (val) {
                  if (val.isEmpty ) {
                    return "ادخل الوصف";
                  }
                  else{
                    setState(() {
                      description = val;
                    });
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "رابط العرض",
                          labelStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        controller: _pricecontroller,
                        validator: (val)
                        {
                          if (val.isEmpty) {
                            return "من فضلك ادخل الرابط";
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
              children:
              [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: uploadimages,
                      child: Text("اضافة"),
                      color: Colors.red.shade800,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  //************************************************************
  // start custom button
  Widget _Custombutton(int imagnum, File image)
  {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
            onPressed: ()
            {
              (_pickimage(imagnum));
            },
            child: image == null ? Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
              child: Icon(Icons.add),
            ) : Container(
              height: 120,
              child: Image.file(
                image,
                width: double.infinity,
                fit: BoxFit.fill,
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
  //************************************************************
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
  //**************************************************************
  // start change category and change brand

  void uploadimages()
  {
    if (_formkey.currentState.validate() &&

        productname.isNotEmpty&&
        description.isNotEmpty&&
        price.isNotEmpty
       )
    {
      if (image1 != null)
      {
        setState(() {
          loading = true;
        });
        ProductDatabase().uploadimages(image1, productname).then((list)
        {
          setState(() {
            imgsurl = list;
          });
          if (imgsurl.isNotEmpty)
          {
            ProductDatabase().uploadProduct(
                productname,
                description,

                price,
                imgsurl,
                );
            setState(() {
              loading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Offers()));
            Fluttertoast.showToast(msg: "product added");
          } else {
            Fluttertoast.showToast(msg: "something wrong had happened ");
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "pick the images of the pictures");
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }
  // end upload images
}
