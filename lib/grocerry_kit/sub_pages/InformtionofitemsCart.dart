import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/home_list.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/providers/product.dart';
import 'package:provider/provider.dart';

int quantity = 1;

class InformationofitemCart extends StatefulWidget {
  @override
  _InformationofitemCartState createState() => _InformationofitemCartState();
}

class _InformationofitemCartState extends State<InformationofitemCart> {
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(productCart.productName),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
            child: Builder(
          builder: (context) => Column(
            children: [
              Image.network(
                productCart.productImageRef,
                height: 250,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 485.4),
                color: Colors.grey[300],
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          productCart.productName,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          productCart.productDescription,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              " £ " + productCart.productPrice,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            shape: StadiumBorder(),
                            height: 50,
                            minWidth: 150,
                            onPressed: () async {
                              double price =
                                  double.parse(productCart.productPrice);
                              QuerySnapshot cartdocs = await Firestore.instance
                                  .collection(users_collection)
                                  .document(userid)
                                  .collection('cart')
                                  .where('name',
                                      isEqualTo: productCart.productName)
                                  .getDocuments();
                              if (cartdocs.documents.length > 0) {
                                Firestore.instance
                                    .collection(users_collection)
                                    .document(userid)
                                    .collection('cart')
                                    .document(cartdocs.documents[0].documentID)
                                    .updateData({'quantity': productCart}).then(
                                        (value) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Item added to cart",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    duration: Duration(milliseconds: 1000),
                                  ));
                                }).catchError((e) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Error. Please Check your internet connection.",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    duration: Duration(milliseconds: 1000),
                                  ));
                                });
                              } else {
                                Firestore.instance
                                    .collection(users_collection)
                                    .document(userid)
                                    .collection('cart')
                                    .add({
                                  'price': price,
                                  'image': productCart.productImageRef,
                                  'name': productCart.productName,
                                  'quantity': quantity,
                                  'subtotal': price,
                                  'description': descriptionController.text
                                }).then((value) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Item added to cart",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    duration: Duration(milliseconds: 1000),
                                  ));
                                }).catchError((e) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "Error. Please Check your internet connection.",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    duration: Duration(milliseconds: 1000),
                                  ));
                                });
                              }
                            },
                            child: Text(
                              "Add to Order",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            color: Colors.deepOrangeAccent,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quantity",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.deepOrange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        quantity = quantity - 1;
                                      });
                                    }),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.deepOrange,
                                    ),
                                    onPressed: () {
                                      print("hii");
                                      setState(() {
                                        quantity = quantity + 1;
                                      });
                                      print(quantity);
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: new InputDecoration(
                              hintMaxLines: 2,

                              hintText: productCart.productDocId,
                              hintStyle: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.grey,
                                  fontSize: 18),

                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "Enter some intruction";
                              } else {
                                return null;
                              }
                            },
                            style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     height: 45,
              //     color: Theme.of(context).accentColor,
              //     alignment: Alignment.center,
              //     child: GestureDetector(
              //       onTap: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) {
              //           return CartPage();
              //         }));
              //       },
              //       child: Row(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Container(
              //             alignment: Alignment.center,
              //             width: 50,
              //             height: 35,
              //             margin: EdgeInsets.symmetric(horizontal: 15),
              //             decoration: BoxDecoration(
              //                 color: Theme.of(context).buttonColor,
              //                 border:
              //                     Border.all(color: Colors.black54, width: 1),
              //                 borderRadius: BorderRadius.circular(4)),
              //             child: Text(
              //               "0",
              //               // '$_cartItemCount',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(fontSize: 22, color: Colors.white),
              //             ),
              //           ),
              //           Text(
              //             "Dollar",
              //             // '£$_subtotal',
              //             style: TextStyle(fontSize: 22, color: Colors.white),
              //           ),
              //           Expanded(
              //             child: Text(
              //               'View Basket\t',
              //               softWrap: true,
              //               textAlign: TextAlign.end,
              //               style: TextStyle(fontSize: 22, color: Colors.white),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        )));
  }
}
