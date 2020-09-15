import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/admin_settings_page.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/category_all_pager.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/hello.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/home_list.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/order_history.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/utils/cart_icons_icons.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static const routeName = "/storeHomepage";

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
//  NavigationBarFunctions navigationBarFunctions = NavigationBarFunctions();
  List<Widget> _widgetList;

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

  int _index = 1;
  final controller = PageController(initialPage: 1, keepPage: true);

  void pageChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      controller.animateToPage(index,
          duration: Duration(milliseconds: 50), curve: Curves.ease);
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),

      body: _prefloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    pageChanged(index);
                  },
                  children: <Widget>[
                    Hello(),
                    CategoryPager(currentUserId),
                    OrderHistory(currentUserId),
                    CouponDeliveryPage()
                  ],
                ),
                if (_index != 0)
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection(users_collection)
                          .document(currentUserId)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center();
                        }
                        final snapShotData = snapshot.data.documents;
                        if (snapShotData.length > 0) {
                          _subtotal = 0;
                          _cartItemCount = 0;
                          snapShotData.forEach((element) {
                            _cartItemCount += element.data['quantity'];
                            _subtotal += element.data['price'] *
                                element.data['quantity'];
                          });
                        }
//                      setState(() {
//                        _prefloading = false;
//                      });

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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).buttonColor,
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(
                                      '$_cartItemCount',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    '£' + _subtotal.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'View Basket\t',
                                      softWrap: true,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
              ],
            ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.black87,
//          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.deepOrange),
//          textTheme: Theme.of(context)
//              .textTheme
//              .copyWith(caption: TextStyle(color: Theme.of(context).accentColor))
      ),
      child: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,

//      backgroundColor: Theme.of(context).primaryColor,
//      fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          bottomTapped(index);
        },
        showUnselectedLabels: true,
        unselectedFontSize: 16,
        selectedFontSize: 16,
        elevation: 0,
        iconSize: 30,
        unselectedLabelStyle: TextStyle(),
        selectedLabelStyle: TextStyle(),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
//                size: 30,
//                color: Colors.black,
              ),
              title: Text('Home', style: TextStyle())),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storage,
//                size: 30,
              ),
              title: Text('Menu', style: TextStyle())),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.insert_drive_file,
//                size: 30,
              ),
              title: Text('My Orders', style: TextStyle())),
          BottomNavigationBarItem(
              icon: Icon(
                CartIcons.account,
//                size: 30,
              ),
              title: Text(
                'Account',
                style: TextStyle(),
              ))
        ],
      ),
    );
  }
}
