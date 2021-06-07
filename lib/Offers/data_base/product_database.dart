import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
class ProductDatabase
{
  Firestore _firestore = Firestore.instance;
  // start upload images
  Future<List<String>> uploadimages(File imgfile1, String productName) async
  {
    List<String> uploadedimages = [];
    var id1 = Uuid();

    final FirebaseStorage storage = FirebaseStorage.instance;
    final String imgname1 = "${productName + id1.v1()}.jpg";

    String imgurl1;

    StorageUploadTask task1 = storage.ref().child(imgname1).putFile(imgfile1);

    StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snap1) {
      return snap1;
    });

    imgurl1 = await snapshot1.ref.getDownloadURL();

    uploadedimages = [imgurl1,];
    return uploadedimages;
  }
  // end upload images
  //**************************************************************
  // start upload product
  void uploadProduct(
      String name,
      String description,

      String price,
      List<String> imgsurl,
      )
  {
    var id = Uuid();
    String productid = id.v1();
    try {
      _firestore.collection('products').document(productid).setData({
        'name': name,
        "description": description,

        "price": price,
        "images url": imgsurl,
      });
    }catch (e) {
    }
  }
  // end upload product
  //**************************************************************
 // start update product
  void updateProduct(
      String productid,
      String name,
      String description,

      String price,

      List<String> imgsurl,
      ) {
    try {
      _firestore.collection('products').document(productid).setData({
        'name': name,
        "description": description,

        "price": price,
        "images url": imgsurl,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  // end update product
  //**************************************************************
  // start getAll products
  Future<List<DocumentSnapshot>> getallproducts() async
  {
    List<DocumentSnapshot> documentSnapshot;


      QuerySnapshot querytSnapshot =
      await Firestore.instance.collection("products").getDocuments();
      documentSnapshot = querytSnapshot.documents;

    return documentSnapshot;
  }
  // end getAll products
  //****************************************************************
  // start get suggestions
  Future<List<DocumentSnapshot>> getSuggestions(String pattern) async
  {
    List<DocumentSnapshot> documentSnapshot;
    QuerySnapshot querytSnapshot = await Firestore.instance.collection("products").where("name",isEqualTo: pattern).getDocuments();
    documentSnapshot = querytSnapshot.documents;
    return documentSnapshot;
  }
  // end get suggestions
  //****************************************************************
  // start delete products
  void deleteproducts(List<String> products) async
  {
    for (String id in products) {
      await Firestore.instance.collection("products").document(id).delete();
    }
  }
  // end delete products
  //****************************************************************
  // start get product count
  Future<int> productCount() async
  {
    int count = 0;
    await getallproducts().then((value) => count = value.length);
    return count;
  }
  // end get product count
}