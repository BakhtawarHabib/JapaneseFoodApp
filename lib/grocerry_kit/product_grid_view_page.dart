import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/providers/product.dart';
import 'package:provider/provider.dart';

import 'category_products_package/add_product.dart';

class ProductGridView extends StatefulWidget {
  final String categoryDocid;
  final String categoryName;

  ProductGridView(this.categoryDocid, this.categoryName);

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  bool _prefloading = false;
  String currentUserId;
  double _subtotal = 0;
  int _cartItemCount = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _prefloading = true;
      });
      FirebaseUser authResult = await FirebaseAuth.instance.currentUser();
      setState(() {
        currentUserId = authResult.uid;
        _prefloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Theme.of(context).buttonColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(widget.categoryName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        actions: <Widget>[
//          GestureDetector(
//              onTap: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return AddProductPage(
//                    categoryDocId: widget.categoryDocid,
//                  );
//                }));
//              },
//              child: Row(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(right: 8.0),
//                    child: Text("Add Product",
//                        style: TextStyle(color: Colors.white)),
//                  )
//                ],
//              ))
        ],
      ),
      body: _prefloading == true
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 45),
                child: categoryItems(),
              ),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection(users_collection)
                      .document(currentUserId)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    }
                    final snapShotData = snapshot.data.documents;
                    if (snapShotData.length > 0) {
                      _subtotal = 0;
                      _cartItemCount = 0;
                      snapShotData.forEach((element) {
                        _cartItemCount += element.data['quantity'];
                        _subtotal +=
                            element.data['price'] * element.data['quantity'];
                      });
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 45,
                        color: Theme.of(context).accentColor,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CartPage();
                            }));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 35,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).buttonColor,
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  '$_cartItemCount',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                              Text(
                                '£$_subtotal',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'View Basket\t',
                                  softWrap: true,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ]),
    );
  }

  Widget categoryItems() {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection(category_collection)
              .document(widget.categoryDocid)
              .collection(products_collection)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final snapShotData = snapshot.data.documents;
            if (snapShotData.length == 0) {
              return Center(
                child: Text("No products added"),
              );
            }
            return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  );
                },
                itemCount: snapShotData.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];
                  ProductModel product =
                      Provider.of<Product>(context).convertToProductModel(data);
                  return Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 30, top: 4, bottom: 4, right: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 110,
                          height: 110,
                          //margin: EdgeInsets.only(left: 5),
                          child: CircleAvatar(
                            maxRadius: 55,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                NetworkImage(product.productImageRef),
                          ),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(
                                product.productName,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                product.productDescription,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: 17,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "£" + product.productPrice,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      double price =
                                          double.parse(product.productPrice);
                                      Firestore.instance
                                          .collection(users_collection)
                                          .document(currentUserId)
                                          .collection('cart')
                                          .add({
                                        'price': price,
                                        'image': product.productImageRef,
                                        'name': product.productName,
                                        'quantity': 1,
                                        'subtotal': price
                                      }).then((value) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "Item added to cart",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          duration:
                                              Duration(milliseconds: 1000),
                                        ));
                                      }).catchError((e) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "Error. Please Check your internet connection.",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          duration:
                                              Duration(milliseconds: 1000),
                                        ));
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
//                                      RoundedRectangleBorder(
//                                          borderRadius: BorderRadius.circular(30.0)),
                                        alignment: Alignment.center,
                                        height: 32,
                                        width: 65,
                                        child: Text(
                                          'BUY',
                                          style: TextStyle(
                                              letterSpacing: 1.1,
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  )
                                ],
                              )
                            ]))
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
