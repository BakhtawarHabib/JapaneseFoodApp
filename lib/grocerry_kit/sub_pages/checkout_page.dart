import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japfooduser/payment_service.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/providers/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mailgun/mailgun.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final double discountPercentage;
  final double deliveryCharges;
  final double subtotal;
  final double total;
  final String time;

  CheckoutPage({
    @required this.discountPercentage,
    @required this.deliveryCharges,
    @required this.subtotal,
    @required this.total,
    @required this.time,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _selectPaymentMethod = false;
  String _paymentMethod = '';
  bool _isLoading = false;
  Color _cartItemColor = Colors.white70;
  String _deliveryTime = "";
  bool _scheduleDeliveryTime = false;
  bool _selectDelivery = false;
  bool _orderSuccessful = false;

  TextEditingController _addressController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _prefloading = false;
  String currentUserId;
  String currentUserEmail;

  @override
  void initState() {
    StripeService.init();
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _prefloading = true;
      });
      FirebaseUser authResult = await FirebaseAuth.instance.currentUser();
      setState(() {
        currentUserId = authResult.uid;
        currentUserEmail = authResult.email;
        _prefloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
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
        automaticallyImplyLeading: false,
        title: Text('Checkout',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: _prefloading == true
          ? Center(child: CircularProgressIndicator())
          : _orderSuccessful == true
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                      size: 220,
                    ),
                    Text(
                      "Congratulations!! Your Order has been Recieved",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//            ///Column for Delivery Timings
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                    decoration: BoxDecoration(
//                        border: Border.all(color: Colors.grey, width: 2),
//                        shape: BoxShape.rectangle,
//                        borderRadius: BorderRadius.circular(8),
//                        color: _cartItemColor),
//                    child: Column(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        //Row to show delivery time
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Delivery Time:",
//                              style: TextStyle(
//                                fontSize: 22,
//                                fontWeight: FontWeight.w600,
//                              ),
//                            ),
//                            Text(
//                              _deliveryTime,
//                              style: TextStyle(
//                                color: Theme.of(context).primaryColor,
//                                fontSize: 22,
//                                fontWeight: FontWeight.w500,
//                              ),
//                            ),
//                          ],
//                        ),
//                        SizedBox(
//                          height: 16,
//                        ),
//                        //Delivery timings buttons hours
//                        if (_selectDelivery == false)
//                          FlatButton(
//                            onPressed: () {
//                              setState(() {
//                                //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
//                                _scheduleDeliveryTime = false;
//                                _selectDelivery = true;
//                              });
//                            },
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                "Select Delivery Time",
//                                style: TextStyle(
//                                    fontSize: 20,
//                                    fontWeight: FontWeight.w500,
//                                    color: Hexcolor('#0644e3')),
//                              ),
//                            ),
//                          ),
//
//                        if (_selectDelivery == true)
//                          Container(
////                            height: 50,
//                            child: StreamBuilder(
//                              stream: Firestore.instance
//                              //TODO
//                                  .collection('delivery')
//                                  .where('status', isEqualTo: 'active')
//                                  .orderBy('deliveryTime')
//                                  .snapshots(),
//                              builder: (context, AsyncSnapshot snapshot) {
//                                switch (snapshot.connectionState) {
//                                  case ConnectionState.waiting:
//                                    return Center(
//                                        child: CircularProgressIndicator());
//                                    break;
//                                  default:
//                                    return ListView.builder(
//                                        shrinkWrap: true,
//                                        physics: ClampingScrollPhysics(),
////                                        scrollDirection: Axis.horizontal,
//                                        itemCount:
//                                            snapshot.data.documents.length,
//                                        itemBuilder: (context, index) {
//                                          return FlatButton(
//                                            onPressed: () {
//                                              setState(() {
//                                                _deliveryTime = snapshot
//                                                    .data
//                                                    .documents[index]
//                                                    .data['deliveryTime'];
//                                                _selectDelivery = false;
//                                                _scheduleDeliveryTime = false;
//                                              });
//                                            },
//                                            child: Padding(
//                                              padding:
//                                                  const EdgeInsets.all(8.0),
//                                              child: Text(
//                                                "Delivery within " +
//                                                    snapshot
//                                                        .data
//                                                        .documents[index]
//                                                        .data["deliveryTime"],
//                                                style: TextStyle(
//                                                    fontSize: 20,
//                                                    fontWeight: FontWeight.w500,
//                                                    color: Theme.of(context)
//                                                        .primaryColor),
//                                              ),
//                                            ),
//                                          );
//                                        });
//                                }
//                              },
//                            ),
//                          ),
//                        //delivery time buttons schedule
//                        if (_scheduleDeliveryTime == false)
//                          FlatButton(
//                            onPressed: () {
//                              setState(() {
//                                //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
//                                _scheduleDeliveryTime = true;
//                                _selectDelivery = false;
//                              });
//                            },
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                "Schedule your own Delivery",
//                                style: TextStyle(
//                                    fontSize: 20,
//                                    fontWeight: FontWeight.w500,
//                                    color: Theme.of(context).accentColor),
//                              ),
//                            ),
//                          ),
//                        if (_scheduleDeliveryTime == true)
//                          Container(
//                            height: 300,
//                            child: StreamBuilder(
//                              stream: Firestore.instance
//                              //TODO
//                                  .collection('schedule')
//                                  .where('status', isEqualTo: 'active')
//                                  .orderBy('t')
//                                  .snapshots(),
//                              builder: (context, AsyncSnapshot snapshot) {
//                                switch (snapshot.connectionState) {
//                                  case ConnectionState.waiting:
//                                    return Center(
//                                        child: CircularProgressIndicator());
//                                    break;
//                                  default:
//                                    return ListView.builder(
//                                        shrinkWrap: true,
//                                        physics: ClampingScrollPhysics(),
//                                        //scrollDirection: Axis.horizontal,
//                                        itemCount:
//                                            snapshot.data.documents.length,
//                                        itemBuilder: (context, index) {
//                                          return Container(
//                                            alignment: Alignment.centerLeft,
//                                            child: FlatButton(
//                                              onPressed: () {
//                                                setState(() {
//                                                  _deliveryTime = snapshot
//                                                      .data
//                                                      .documents[index]
//                                                      .data['deliveryTime'];
//                                                  _scheduleDeliveryTime = false;
//                                                  _selectDelivery = false;
//                                                });
//                                              },
//                                              child: Padding(
//                                                padding:
//                                                    const EdgeInsets.all(4.0),
//                                                child: Text(
//                                                  "From: " +
//                                                      snapshot
//                                                          .data
//                                                          .documents[index]
//                                                          .data["deliveryTime"],
//                                                  style: TextStyle(
//                                                      fontSize: 20,
//                                                      fontWeight:
//                                                          FontWeight.w500,
//                                                      color: Theme.of(context)
//                                                          .primaryColor),
//                                                ),
//                                              ),
//                                            ),
//                                          );
//                                        });
//                                }
//                              },
//                            ),
//                          )
//                      ],
//                    ),
//                  ),

                      ///Column for Payment Methods
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.5)),
                            shape: BoxShape.rectangle,
                            color: _cartItemColor),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //Row to show delivery time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Payment Method:",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  _paymentMethod,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),

                            ///Payment Method Buttons
                            if (_selectPaymentMethod == false)
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    //_deliveryTime = snapshot.data.documents[index].data['deliveryTime'];
                                    _selectPaymentMethod = true;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Select Payment Method",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                              ),
                            if (_selectPaymentMethod == true)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _paymentMethod = "Cash On Delivery";
                                      _selectPaymentMethod = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Cash On Delivery",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            if (_selectPaymentMethod == true)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _paymentMethod = "Pay via Card";
                                      _selectPaymentMethod = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Pay via Card",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      ///Column for user details
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: _cartItemColor),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(15),
                              height: 50,
                              child: TextField(
                                maxLines: 1,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(15),
                              height: 50,
                              child: TextField(
                                maxLines: 1,
                                controller: _numberController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      currentUserEmail,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(15.0),
                              height: 100,
                              child: TextField(
                                maxLines: 5,
                                controller: _addressController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 17),
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///Order Buttons
                      _isLoading == true
                          ? CircularProgressIndicator()
                          : Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              height: 50,
                              width: 150,
                              child: FlatButton(
                                shape: StadiumBorder(),
                                color: Colors.green,
                                child: Text('Order Now',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                onPressed: () {
                                  if (_nameController.text == "") {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Name cannot be empty.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  if (_numberController.text == "") {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Number cannot be empty.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  if (_addressController.text == "") {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Address cannot be empty.",
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  if (_paymentMethod == "") {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Please select a payment method."),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
//                  if (_deliveryTime == "") {
//                    _scaffoldKey.currentState.showSnackBar(SnackBar(
//                      content:
//                      Text("Please select a delivery time."),
//                      backgroundColor: Colors.red,
//                    ));
//                  }

//                              _deliveryTime != "" &&
                                  if (_paymentMethod != "" &&
                                      _addressController.text != "" &&
                                      _nameController.text != "" &&
                                      _numberController.text != "") {
                                    ///

                                    _addOrder().catchError((err) {
                                      setState(() {
                                        _isLoading = false;
                                        _orderSuccessful = false;
                                      });
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "An error has occured,Please try Later"),
                                        backgroundColor: Colors.red,
                                      ));
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                              ),
                            ),

                      ///Cancel Order Buttons
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        height: 50,
                        width: 150,
                        child: FlatButton(
                          shape: StadiumBorder(),
                          color: Colors.red,
                          child: Text('Cancel Order',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await Firestore.instance
                                .collection(users_collection)
                                .document(currentUserId)
                                .collection('cart')
                                .getDocuments()
                                .then((QuerySnapshot snapshot) {
                              for (DocumentSnapshot doc in snapshot.documents) {
                                doc.reference.delete();
                              }
                            }).then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  ///place order Function
  Future<void> _addOrder() async {
    QuerySnapshot cartItems;
    await Firestore.instance
        .collection(users_collection)
        .document(currentUserId)
        .collection('cart')
        .getDocuments()
        .then((QuerySnapshot value) {
      cartItems = value;
    });
    DateTime timestamp = DateTime.now();

    try {
      String amount = (widget.subtotal * 100).toStringAsFixed(0);
      if (_paymentMethod == 'Pay via Card') {
        StripeTransactionResponse response =
            await StripeService.payViaNewCard(amount: '400', currency: 'USD');
        if (response.success == false) {
          showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.red[400],
                    )),
                title: Text(response.message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
          throw Exception;
        }
      }
      setState(() {
        _isLoading = true;
      });
      await Firestore.instance.collection('orders').add({
        'status': 'Pending',
        'name': _nameController.text,
        'phoneNumber': _numberController.text,
        "Address": _addressController.text,
        "email": currentUserEmail,
        "userUid": currentUserId,
        'deliveryCharges': widget.deliveryCharges.toString(),
        'subTotal': widget.subtotal.toString(),
        'discPercentage': widget.discountPercentage.toStringAsFixed(2),
        'deliveryTime': _deliveryTime,
        'dateTime': timestamp.toIso8601String(),
        'completed': false,
        'time': widget.time,
        'paymentMethod': _paymentMethod,
        'products': cartItems.documents
            .map((DocumentSnapshot cp) => {
                  'productName': cp.data['name'],
                  'productImageRef': cp.data['image'],
                  'productQuantity': cp.data['quantity'].toString(),
                  'productPrice': cp.data['price'].toString(),
                  "product": cp.data['subtotal'].toString(),
                  "description": cp.data['description'],
                })
            .toList(),
      });
      await Firestore.instance
          //TODO
          .collection(users_collection)
          .document(currentUserId)
          .collection('cart')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
        }
      });
      setState(() {
        _isLoading = false;
        _orderSuccessful = true;
      });

//      var mailgun = MailgunMailer(
//          domain: "sandboxb3269b02eb6f4bc789076e97bfb4a3bd.mailgun.org",
//          apiKey: "39df356f312ceaa3dfcc1cc1b7e7f09d-a65173b1-a61e6b40");
//
//      List<String> a = [
//        "pranay.moghatal@gmail.com"
//      ];
//      await mailgun.send(
//          from: "doodelservicesapp@gmail.com",
//          to: a,
//          subject: "Doodel App",
//          text:"You have received a new order.").then((value) {
//            print(value.status);
//      });

    } catch (err) {
      print(err);
      showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(
                  color: Colors.red[400],
                )),
            title: Text(err.message),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.red[400]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));

//     var message =
//         "Payment couldn't be verified.";
//     _scaffoldKey.currentState.showSnackBar(SnackBar(
//       content: Text(
//         message,
//       ),
//       backgroundColor: Colors.red,
//     ));
    }
  }
}
