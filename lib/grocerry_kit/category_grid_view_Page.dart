import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:japfooduser/grocerry_kit/product_grid_view_page.dart';
import 'package:japfooduser/grocerry_kit/sub_pages/cartPage.dart';
import 'package:japfooduser/providers/category.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:provider/provider.dart';

import 'category_products_package/add_category.dart';

class CategoryGridView extends StatefulWidget {
  @override
  _CategoryGridViewState createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: categoryItems(),
      ),
    );
  }

  Widget categoryItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
          stream:
              Firestore.instance.collection(category_collection).snapshots(),
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
            return GridView.builder(
                itemCount: snapShotData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  var data = snapShotData[index];
                  var category = Provider.of<Category>(context)
                      .convertToCategoryModel(data);
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductGridView(category.categoryDocId,
                                    category.categoryName);
                              }));
                            },
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2.0,
                                        spreadRadius: 2.0,
                                        color: Colors.deepOrangeAccent)
                                  ],
                                  color:
                                      Colors.deepOrangeAccent.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          category.categoryImageRef))),

                              // child: CircleAvatar(
                              //   maxRadius: 65,
                              //   backgroundColor: Colors.grey[300],
                              //   backgroundImage:
                              //       NetworkImage(category.categoryImageRef),
                              // ),
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          category.categoryName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
//                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
//                          Container(
//                            alignment: Alignment.centerRight,
//                            child: GestureDetector(
//                              onTap: () {
//                                Navigator.push(context,
//                                    MaterialPageRoute(builder: (context) {
//                                  return UpdateCategoryPage(
//                                    categoryModel: category,
//                                  );
//                                }));
//                              },
//                              child: Icon(
//                                Icons.edit,
//                                size: 22,
//                              ),
//                            ),
//                          )
                      ]);
                });
          }),
    );
  }
}
