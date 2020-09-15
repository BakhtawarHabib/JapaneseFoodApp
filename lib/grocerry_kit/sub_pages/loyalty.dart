import 'package:flutter/material.dart';

class Loyalty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).buttonColor,
//        backgroundColor: Hexcolor('#0644e3'),

        title: Text('\tLoyalty Points',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        actions: <Widget>[
//          GestureDetector(
//              onTap: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return AddCategoryPage();
//                }));
//              },
//              child: Row(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(right: 8.0),
//                    child: Text("Add Category",
//                        style: TextStyle(color: Colors.white)),
//                  )
//                ],
//              ))
        ],
      ),
      body: Container(height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
//        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/loyalty.jpeg'), fit: BoxFit.fitHeight)),

      ),
    );
  }
}
