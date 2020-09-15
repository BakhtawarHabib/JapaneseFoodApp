import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:japfooduser/providers/category.dart';
import 'package:japfooduser/providers/collection_names.dart';
import 'package:japfooduser/widgets/custom_update_image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../style_functions.dart';

// ignore: must_be_immutable
class UpdateCategoryPage extends StatefulWidget {
  static const routeName = "/updateCategoryPage";
  UpdateCategoryPage({this.categoryModel});
  CategoryModel categoryModel;
  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _categoryName;
  String _categoryImageRef;
  File _newImageFile;
//  var _isLoading;
  StyleFunctions styleFunctions = StyleFunctions();

  @override
  void initState() {
   _categoryImageRef = widget.categoryModel.categoryImageRef;
    super.initState();
  }

  void _pickedImage(File url) {
    _newImageFile = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Hexcolor('#0644e3'),
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
        title: Text(
            "Edit Category",style: TextStyle(color: Colors.white,fontSize: 24)
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Text(
              'Edit Category',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    UserUpdateImagePicker(_pickedImage,widget.categoryModel.categoryImageRef),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
                        initialValue: widget.categoryModel.categoryName,
                          validator: (val) {
                            if (val.trim().isEmpty) {
                              return "Category Name be empty.";
                            } else if (val.trim().length > 30) {
                              return "Name cannot be 30+ characters";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _categoryName = val.trim();
                          },
                          keyboardType: TextInputType.text,
                          style: styleFunctions.formFieldTextStyle(),
                          decoration: styleFunctions
                              .formTextFieldDecoration("Category Name")),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Align(
                      child: SizedBox(
                        height: 50.0,
                        width: 270.0,
                        child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //Only gets here if the fields pass
                              _formKey.currentState.save();
                              final CategoryModel updatedCategory = CategoryModel(
                                  categoryDocId: widget.categoryModel.categoryDocId,
                                  categoryName: _categoryName,
                                  categoryImageRef: _categoryImageRef);

                              //TODO Check values and navigate to new page
                              Provider.of<Category>(context, listen: false)
                                  .updateCategory(
                                  updatedCategory,_newImageFile)
                                  .then((e) {
                                Navigator.of(context).pop();
                                // Provider.of<Products>(context).login();
                              })
                                  .then((value) => {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Update Category.'),
                                    content: Text(
                                        'The changes have been saved.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Okay',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                )
                              })
                                  .catchError((e) {
                                print(e);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('An error occurred!'),
                                    content: Text(
                                        'Something went wrong. Please Try again later.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Okay',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Save Changes',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    Align(
                      child: SizedBox(
                        height: 50.0,
                        width: 270.0,
                        child: FlatButton(
                          onPressed: () {

                              //Only gets here if the fields pass
                              //TODO Check values and navigate to new page
                              Firestore.instance
                                  .collection(category_collection)
                                  .document(widget.categoryModel.categoryDocId).delete().then((e) {
                                Navigator.of(context).pop();
                                // Provider.of<Products>(context).login();
                              })
                                  .then((value) => {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Delete Category.'),
                                    content: Text(
                                        "The category has been deleted"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Okay',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                )
                              })
                                  .catchError((e) {
                                print(e);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('An error occurred!'),
                                    content: Text(
                                        'Something went wrong. Please Try again later.'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Okay',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });

                          },
                          color: Theme.of(context).primaryColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Delete Category',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
