import 'package:flutter/material.dart';
import 'package:japfooduser/providers/category.dart';
import 'package:japfooduser/widgets/custom_image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../style_functions.dart';

class AddCategoryPage extends StatefulWidget {
  static const routeName = "/addNewCategoryPage";
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _categoryName;
  File _categoryImageFile;
//  var _isLoading;
  StyleFunctions styleFunctions = StyleFunctions();

  void _pickedImage(File image) {
    _categoryImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomBar(),
      appBar: AppBar(
//        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
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
            "Add Category",style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)
        ),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    UserImagePicker(_pickedImage),
                    SizedBox(height: 16,),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextFormField(
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
                      height: 28,
                    ),
                    Align(
                      child: SizedBox(
                        height: 50.0,
                        width: 190.0,
                        child: FlatButton(
                          onPressed: () {
                            if (_categoryImageFile == null) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Please pick an image'),
                                backgroundColor: Theme
                                    .of(context)
                                    .errorColor,));
                              return;
                            }
                            if (_formKey.currentState.validate()) {
                              //Only gets here if the fields pass
                              _formKey.currentState.save();
                              final CategoryModel newCategory = CategoryModel(
                                  categoryDocId: "does not matter",
                                  categoryName: _categoryName,
                                  categoryImageRef: "doesnot matter");

                              //TODO Check values and navigate to new page
                              Provider.of<Category>(context, listen: false)
                                  .addNewCategory(
                                      newCategory, _categoryImageFile)
                                  .then((e) {
                                    Navigator.of(context).pop();
                                    // Provider.of<Products>(context).login();
                                  })
                                  .then((value) => {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Category Created'),
                                            content: Text(
                                                'The New category has been Created.'),
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
                                                        .buttonColor)),
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
                          color: Theme.of(context).accentColor,
                          //Color.fromRGBO(58, 66, 86, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Add Category',
                            style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w400),
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
