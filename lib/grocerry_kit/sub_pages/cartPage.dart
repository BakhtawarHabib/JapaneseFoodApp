import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/InformationofItems.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/InformtionofitemsCart.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/loyalty.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/providers/product.dart';
import 'package:japfooduser/providers/user.dart';
import 'package:japfooduser/widgets/custom_image_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';

import '../../style_functions.dart';
import 'checkout_page.dart';

ProductModel productCart;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  StyleFunctions formFieldStyle = StyleFunctions();
  TextEditingController _couponCodeController = TextEditingController();
  TextEditingController _extraStuffController = TextEditingController();
  bool promoCodeChecker = true;
  double _discountPercentage = 0;
  double _discount = 0;
  double _deliveryCharges = 0;
  double _subtotal = 0;
  double _total = 0;
  Color _cartItemColor = Colors.white70;
  int hour = 0;
  int min = 0;
  String time = 'As soon as Possible';

  @override
  void dispose() {
    _couponCodeController.dispose();
    _extraStuffController.dispose();
    super.dispose();
  }

  bool _prefloading = false;
  String currentUserId;

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
    return Material(
      child: Scaffold(
        appBar: AppBar(
//        centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.deepOrangeAccent,
//        backgroundColor: Hexcolor('#0644e3'),

          title: Text('\tReview Basket',
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
        backgroundColor: Colors.white,
        body: _prefloading == true
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: Firestore.instance
                    .collection(users_collection)
                    .document(currentUserId)
                    .collection('cart')
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
                      child: Text("Cart is empty.",
                          style: TextStyle(
                              color: Colors.deepOrange, fontSize: 30)),
                    );
                  }
                  if (snapShotData.length > 0) {
                    _subtotal = 0;
                    snapShotData.forEach((element) {
                      _subtotal +=
                          element.data['price'] * element.data['quantity'];
                    });

                    if (_subtotal < 0.001) {
                      _deliveryCharges = 0;
                    } else if (_subtotal < 12) {
                      _deliveryCharges = 2;
                    } else {
                      _deliveryCharges = 0;
                    }

                    _total =
                        _subtotal - (_subtotal * _discountPercentage * 0.01);
                    _discount = _subtotal - _total;
                    _total = _total + _deliveryCharges;
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                // controller: passwordController,

                                decoration: new InputDecoration(
                                  hintMaxLines: 2,
                                  hintText:
                                      "Instruction to driver,e.g knock on back door, lift not working",
                                  hintStyle: TextStyle(
                                      letterSpacing: 0.5,
                                      color: Colors.grey,
                                      fontSize: 18),

                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),

                                style: new TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDialog();
                          },
                          child: Container(
                            height: 45,
                            child: ListTile(
                                leading: Column(children: [
                                  Icon(Icons.timer),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Delivery Time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                        fontSize: 14),
                                  ),
                                ]),
                                title: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                    iconSize: 30,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    onPressed: () {
                                      _showDialog();
                                    })),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

//                    ///List of Products
//                    Container(
//                      alignment: Alignment.centerLeft,
//                      padding: EdgeInsets.only(left: 16, top: 4),
//                      child: Text(
//                        "Cart Products",
//                        style: TextStyle(
//                          fontSize: 22,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                    ),
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
//                          border: Border.all(color: Colors.grey, width: 2),
//                          borderRadius: BorderRadius.circular(8),
                              color: Colors.white70),
                          height: MediaQuery.of(context).size.height * .43,
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.red,
                                thickness: 0.5,
                              );
                            },
                            shrinkWrap: true,
                            itemCount: snapShotData.length,
                            itemBuilder: (context, index) {
                              return _listItem(snapShotData[index]);
                            },
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Delivery Charges",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "£" + _deliveryCharges.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            )),

                        SizedBox(
                          height: 6,
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "£" + _total.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            )),

                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 4, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Promo Code",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              Container(
                                color: Colors.white,

                                height: 50,
                                width: MediaQuery.of(context).size.width * .4,
//                      padding: EdgeInsets.only(
//                          left: 16, right: 16, top: 8, bottom: 8),
                                child: TextField(
                                  controller: _couponCodeController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Code',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.deepOrangeAccent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  if (_couponCodeController.text
                                      .trim()
                                      .isNotEmpty) {
                                    Firestore.instance
                                        .collection(discount_coupons_collection)
                                        .where('promoCode',
                                            isEqualTo: _couponCodeController
                                                .text
                                                .trim())
                                        .getDocuments()
                                        .then((value) {
                                      if (value.documents.length > 0) {
                                        setState(() {
                                          _discountPercentage = double.parse(
                                              value.documents[0]
                                                  .data['discPercentage']);
                                          promoCodeChecker = true;
                                          _couponCodeController.clear();
                                        });
                                      } else {
                                        setState(() {
                                          promoCodeChecker = false;
                                          _couponCodeController.clear();
                                        });
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        if (promoCodeChecker == false)
                          Text(
                            "No such promo code available",
                            style: TextStyle(color: Colors.red),
                          ),
                        if (promoCodeChecker == false)
                          SizedBox(
                            height: 6,
                          ),

                        Divider(
                          color: Colors.red,
                          thickness: 0.6,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Loyalty Order points",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Loyalty();
                                  }));
                                },
                                child: Text(
                                  "VIEW",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                        ),

//                        Divider(
//                          color: Colors.black87,
//                          thickness: 1.5,
//                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          width: 250,
                          child: FlatButton(
                            child: Row(
                              children: <Widget>[
                                Text('Proceed To Checkout',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CheckoutPage(
                                  deliveryCharges: _deliveryCharges,
                                  discountPercentage: _discount,
                                  subtotal: _subtotal,
                                  total: _total,
                                  time: time,
                                );
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  ///An item in Cart
  Widget _listItem(DocumentSnapshot item) {
    UserModel userProfile =
        Provider.of<User>(context, listen: false).userProfile;
    var cartItem = item.data;
    return GestureDetector(
        onTap: () {
          setState(() {
            productCart = ProductModel(
                productPrice: cartItem['price'].toString(),
                productName: cartItem['name'],
                productDocId: cartItem['description'],
                productDescription: cartItem['productDescription'],
                productImageRef: cartItem['image']);
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InformationofitemCart()),
          );
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(color: Colors.white),
          child: ListTile(
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage(
                  cartItem['image'],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 13.0,
                  ),
                  Text(
                    cartItem['name'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "£" + (cartItem['price'] * cartItem['quantity']).toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              trailing: Column(
                children: [
                  Text(
                    'Quantity: 1 x ' + cartItem['quantity'].toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                  Container(
                    height: 38,
//
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(10.0),
//                          splashColor: Colors.red,
                          alignment: Alignment.centerLeft,
                          onPressed: () {
                            //cartItem['quantity']+=1;

                            if (cartItem['quantity'] > 1) {
                              Firestore.instance
                                  .collection(users_collection)
                                  .document(currentUserId)
                                  .collection('cart')
                                  .document(item.documentID)
                                  .updateData(
                                      {'quantity': cartItem['quantity'] - 1});
                            } else {
                              Firestore.instance
                                  .collection(users_collection)
                                  .document(currentUserId)
                                  .collection('cart')
                                  .document(item.documentID)
                                  .delete();
                            }
                          },
                          icon: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        Text(
                          cartItem['quantity'].toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        IconButton(
                          padding: EdgeInsets.all(10.0),
//                          splashColor: Colors.green,
                          alignment: Alignment.centerRight,

                          onPressed: () {
                            Firestore.instance
                                .collection(users_collection)
                                .document(currentUserId)
                                .collection('cart')
                                .document(item.documentID)
                                .updateData(
                                    {'quantity': cartItem['quantity'] + 1});
                          },
                          icon: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ));
//     return Container(
//       decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white70),
//       height: 99,
//       child: Row(children: <Widget>[
//         Container(
//             alignment: Alignment.centerLeft,
//             width: 70,
//             child: CircleAvatar(
//               maxRadius: 30,
//               backgroundImage: NetworkImage(
//                 cartItem['image'],
//               ),
//             )),
//         Expanded(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 height: 10.0,
//               ),
//               Text(
//                 cartItem['name'],
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       "£" +
//                           (cartItem['price'] * cartItem['quantity']).toString(),
//                       style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600]),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Quantity: ",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           Text(
//                             '1 x ' + cartItem['quantity'].toString(),
//                             style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             softWrap: true,
//                           ),
//                         ],
//                       ),
//                       Container(
// //                    width: 122,
// //                  height: 40,
// //                    decoration: BoxDecoration(border: Border.all(color: Colors.black54,width: 1),
// //                    borderRadius: BorderRadius.circular(8)
// //                    ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             IconButton(
//                               padding: EdgeInsets.all(10.0),
// //                          splashColor: Colors.red,
//                               alignment: Alignment.centerLeft,
//                               onPressed: () {
//                                 //cartItem['quantity']+=1;

//                                 if (cartItem['quantity'] > 1) {
//                                   Firestore.instance
//                                       .collection(users_collection)
//                                       .document(currentUserId)
//                                       .collection('cart')
//                                       .document(item.documentID)
//                                       .updateData({
//                                     'quantity': cartItem['quantity'] - 1
//                                   });
//                                 } else {
//                                   Firestore.instance
//                                       .collection(users_collection)
//                                       .document(currentUserId)
//                                       .collection('cart')
//                                       .document(item.documentID)
//                                       .delete();
//                                 }
//                               },
//                               icon: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                     color: Colors.deepOrangeAccent,
//                                     border:
//                                         Border.all(color: Colors.red, width: 1),
//                                     borderRadius: BorderRadius.circular(4)),
//                                 child: Icon(
//                                   Icons.remove,
//                                   color: Colors.white,
//                                   size: 25,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               cartItem['quantity'].toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black45,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               softWrap: true,
//                             ),
//                             IconButton(
//                               padding: EdgeInsets.all(10.0),
// //                          splashColor: Colors.green,
//                               alignment: Alignment.centerRight,

//                               onPressed: () {
//                                 Firestore.instance
//                                     .collection(users_collection)
//                                     .document(currentUserId)
//                                     .collection('cart')
//                                     .document(item.documentID)
//                                     .updateData(
//                                         {'quantity': cartItem['quantity'] + 1});
//                               },
//                               icon: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                     color: Colors.deepOrangeAccent,
//                                     border:
//                                         Border.all(color: Colors.red, width: 1),
//                                     borderRadius: BorderRadius.circular(4)),
//                                 child: Icon(
//                                   Icons.add,
//                                   color: Colors.white,
//                                   size: 25,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   )

// //                  GestureDetector(
// //                  onTap: (){
// //                  Firestore.instance.collection(users_collection).document(currentUserId)
// //                      .collection('cart').document(item.documentID)
// //                      .delete();
// //                  },
// //                    child: Container(
// //                        decoration: BoxDecoration(
// //                            color: Theme.of(context).accentColor,
// //                            borderRadius: BorderRadius.circular(8)
// //                        ),
// ////                                      RoundedRectangleBorder(
// ////                                          borderRadius: BorderRadius.circular(30.0)),
// //                        alignment: Alignment.center,
// //                        height: 32,
// //                        width: 65,
// //                        child: Text(
// //                          'DEL',
// //
// //                          style: TextStyle(letterSpacing: 1.1,
// //                              fontSize: 18,
// //                              color:
// //                              Colors.white,fontWeight: FontWeight.w400),
// //                        )),
// //                  )
//                 ],
//               ),
//             ],
//           ),
//         )
//       ]),
//     );
  }

  double _currentPrice = 1.2;

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Select Time "),
                Text(
                  "24hr Clock",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                )
              ],
            ),
            content: Row(
              children: <Widget>[
                NumberPicker.integer(
                    initialValue: 0,
                    minValue: 0,
                    maxValue: 30,
                    onChanged: (num a) {
                      hour = a;
                      print(hour);
                    }),
                NumberPicker.integer(
                    initialValue: 0,
                    minValue: 0,
                    step: 15,
                    maxValue: 45,
                    onChanged: (num b) {
                      min = b;
                      print(min);
                    }),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      time = hour.toString() + " : " + min.toString();
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
          // return Row(
          //   children: <Widget>[
          //     new NumberPickerDialog.integer(
          //         minValue: 0, maxValue: 24, initialIntegerValue: 0),
          //     NumberPicker.integer(
          //         initialValue: 1, minValue: 1, maxValue: 30, onChanged: null)
          //   ],
          // );
          // decimal(
          //   minValue: 1,
          //   maxValue: 10,
          //   title: new Text("Pick a new price"),
          //   initialDoubleValue: _currentPrice,
          // );
        });
  }
}
