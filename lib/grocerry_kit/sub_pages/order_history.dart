import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/providers/user.dart';
import 'package:provider/provider.dart';
import 'order_Page.dart';

class OrderHistory extends StatefulWidget {
  static const routeName = "/orderHistory";

  final String currentUserId ;
  OrderHistory(this.currentUserId);


  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,backgroundColor: Theme.of(context).buttonColor,
        automaticallyImplyLeading: true,
        title: Text(
          "Order History",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),

      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.all(16),
//              child: Text(
//                "Order History",
//                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.grey),
//              ),
//            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('orders')
                      .where('userUid',isEqualTo: widget.currentUserId)
                      .orderBy('dateTime',descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                        break;
                      default:
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            var data = snapshot.data.documents[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return OrderPage(data);
                                    }));
                              },
                              child: Container(margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 2),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white70),
                                child: ListTile(
                                  title: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 8, top: 4 ,bottom: 4),
                                    child: Text(
                                      "Date: " +
                                          data['dateTime'].split('T').first,
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                      '${data['status']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500
                                      )),
                                  //    trailing: Text(data['status'])
                                ),
                              ),
                            );
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
