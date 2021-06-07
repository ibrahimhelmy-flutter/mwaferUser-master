import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabase {
  Firestore _firestore = Firestore.instance;
  // get all products
  Future<List<DocumentSnapshot>> getallProducts() async {
    List<DocumentSnapshot> _list;
    QuerySnapshot _querySnapshot =
        await _firestore.collection("products").getDocuments();
    _list = _querySnapshot.documents;
    return _list;
  }

  // category products
  Future<List<DocumentSnapshot>> CATProducts(String CATID) async {
    List<DocumentSnapshot> _list;
    QuerySnapshot _querySnapshot = await _firestore
        .collection("coupons")
        .where("category", isEqualTo: CATID)
        .getDocuments();
    _list = _querySnapshot.documents;
    return _list;
  }

  // get all products if search for an one category or all
  Future<List<DocumentSnapshot>> getallproducts(String CAT) async {
    List<DocumentSnapshot> documentSnapshot;
    if ((CAT != null && CAT != "All")) {
      if (CAT != "All") {
        QuerySnapshot querytSnapshot = await Firestore.instance
            .collection("coupons")
            .where("category", isEqualTo: CAT)
            .getDocuments();
        documentSnapshot = querytSnapshot.documents;
      } else if (CAT == "All") {
        QuerySnapshot querytSnapshot =
            await Firestore.instance.collection("coupons").getDocuments();
        documentSnapshot = querytSnapshot.documents;
      }
    } else {
      QuerySnapshot querytSnapshot =
          await Firestore.instance.collection("coupons").getDocuments();
      documentSnapshot = querytSnapshot.documents;
    }
    return documentSnapshot;
  }

  // get suggestions this function for searching if you writ a pattern like "a" you will see all products that start
  // by "a" yes that all EID EID
  Future<List<DocumentSnapshot>> getSuggestions(String pattern) async {
    List<DocumentSnapshot> documentSnapshot;
    List<DocumentSnapshot> finalresult = [];
    QuerySnapshot querytSnapshot =
        await _firestore.collection("coupons").getDocuments();
    documentSnapshot = querytSnapshot.documents;
    documentSnapshot.forEach((value) {
      if (value.data["name"].toString().startsWith(pattern)) {
        finalresult.add(value);
      }
    });
    return finalresult;
  }
}
