import 'package:flutter/material.dart';

class BuildProductRow extends StatelessWidget {
  String txt; String img;
  String des;
  BuildProductRow(this.txt, this.img, this.des);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),

      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // height: 130.0,
        // width: 400.0,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(15.0),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        txt,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                      SizedBox(
                          height: 3.0
                      ),
                      Text(
                        des==null?"":des,
                        style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.w500),
                      ), SizedBox(
                          height: 3.0
                      ),
                      // Text(
                      //   "الفترة من اول يناير حتى منتصف مارس ",
                      //   style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffe7eaed).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(45.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45.0),
                    child: Image.network(
                      img,
                      height: 70.0,
                      width: 70.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
