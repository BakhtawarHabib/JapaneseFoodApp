import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/main.dart';
import 'package:japfooduser/providers/collection_names.dart';

import '../SignIn.dart';

class CouponDeliveryPage extends StatefulWidget {
  @override
  _CouponDeliveryPageState createState() => _CouponDeliveryPageState();
}

class _CouponDeliveryPageState extends State<CouponDeliveryPage> {
//  final _formKey = GlobalKey<FormState>();
////  final _formKey1 = GlobalKey<FormState>();
//  String _couponCode = '';
//  String _discPercentage = '';
//  TextEditingController _first = TextEditingController();
//  TextEditingController _second = TextEditingController();
//  TextEditingController _third = TextEditingController();
//  TextEditingController _helpEmailController = TextEditingController();
//  TextEditingController _helpNumberController = TextEditingController();
////  File _categoryImageFile;
////  void _pickedImage(File image) {
////    _categoryImageFile = image;
////  }
//
//  @override
//  void dispose() {
//    _helpEmailController.dispose();
//    _helpNumberController.dispose();
//    _first.dispose();
//    _second.dispose();
//    _third.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
//        centerTitle: true,
        backgroundColor: Theme.of(context).buttonColor,
        elevation: 0,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
//              Container(
//                margin: EdgeInsets.only(
//                  left: 20, right: 20, ),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      "Loyalty Order points",
//                      style: TextStyle(
//                          fontSize: 18,
//                          fontWeight: FontWeight.w400,
//                          color: Colors.grey
//                      ),
//                    ),
//
//                    FlatButton(
//                      onPressed: () {},
//                      child: Text(
//                        "VIEW",
//                        style: TextStyle(color: Theme.of(context).accentColor,fontSize: 18,fontWeight: FontWeight.w400),
//                      ),
//                    )
//                  ],
//                ),
//              ),
//
//                        Divider(
//                          color: Colors.black87,
//                          thickness: 1.5,
//                        ),
//              SizedBox(height: 16,),
//              ///Available Coupons Section
//              Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.only(left: 16, top: 4),
//                child: Text(
//                  "Available Promo Codes",
//                  style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w400,
//                      color: Colors.grey
//                  ),
//                ),
//              ),
//              Container(height: 150,
//                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                padding:
//                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                decoration: BoxDecoration(
//                    border: Border.all(color: Colors.grey, width: 2),
//                    shape: BoxShape.rectangle,
//                    borderRadius: BorderRadius.circular(8),
//                    color: Colors.white70),
//                child: StreamBuilder(
//                  stream: Firestore.instance
//                      .collection(discount_coupons_collection)
//                      .snapshots(),
//                  builder: (context, AsyncSnapshot snapshot) {
//                    switch (snapshot.connectionState) {
//                      case ConnectionState.waiting:
//                        return Center(
//                            child: CircularProgressIndicator());
//                        break;
//                      default:
//                        return ListView.builder(
//                            shrinkWrap: true,
//                            physics: ClampingScrollPhysics(),
//                            //scrollDirection: Axis.horizontal,
//                            itemCount:
//                            snapshot.data.documents.length,
//                            itemBuilder: (context, index) {
//                              return Padding(
//                                padding: const EdgeInsets.all(4.0),
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Text(
//                                      "code: "+ snapshot.data.documents[index].data['promoCode'],
//                                      style: TextStyle(
//                                          fontSize: 18,
//                                          fontWeight: FontWeight.w500,
//                                          color: Colors.grey
//                                      ),
//                                    ),
//                                    Text(
//                                      snapshot.data.documents[index].data['discPercentage']+"%",
//                                      style: TextStyle(
//                                        color: Theme.of(context).primaryColor,
//                                        fontSize: 18,
//                                        fontWeight: FontWeight.w500,
//                                      ),
//                                    ),
//
//                                  ],
//                                ),
//                              );
//                            });
//                    }
//                  },
//                ),
//              ),
//              SizedBox(height: 80,),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                width: 250,
                child: FlatButton(
                  child: Text('Logout',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignInPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
