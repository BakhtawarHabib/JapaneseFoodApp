import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japfooduser/grocerry_kit/category_grid_view_Page.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/home_list.dart';

class CategoryPager extends StatefulWidget {
  final String currentUserId;
  CategoryPager(this.currentUserId);

  @override
  _CategoryPagerState createState() => _CategoryPagerState();
}

class _CategoryPagerState extends State<CategoryPager> {
  bool _all = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.withOpacity(0.3),
        centerTitle: true,
        brightness: Brightness.dark,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _all = true;
                  });
                },
                child: Container(
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _all == true ? Colors.black87 : Colors.white,
                    border: Border.all(color: Colors.black87, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'All',
                    style: TextStyle(
                        fontSize: 17,
                        color: _all == true ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _all = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 130,
                  decoration: BoxDecoration(
                    color: _all == false ? Colors.black87 : Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        fontSize: 17,
                        color: _all == false ? Colors.white : Colors.black87),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: _all == true ? HomeList(widget.currentUserId) : CategoryGridView(),
    );
  }
}
