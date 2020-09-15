import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'collection_names.dart';

class CategoryModel {
  String categoryName;
  String categoryImageRef;
  String categoryDocId;

  CategoryModel(
      {@required this.categoryName,
      @required this.categoryImageRef,
      @required this.categoryDocId});
}

class Category with ChangeNotifier {
  ///naming conventions for store model for firebase
  String _categoryName = "categoryName";
  String _categoryImageRef = "categoryImage";

  CategoryModel _storeProfile;

  CategoryModel get storeProfile => _storeProfile;

  Future<void> addNewCategory(
      CategoryModel categoryModel, File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(DateTime.now().toString() + ".jpg");
    await ref.putFile(image).onComplete;

    final url = await ref.getDownloadURL();

    await Firestore.instance
        .collection(category_collection)
        .add({
      _categoryName: categoryModel.categoryName,
      _categoryImageRef: url
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateCategory(
      CategoryModel updatedCategoryModel,File image) async {

    if(image != null){
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().toString() + ".jpg");
      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection(category_collection)
          .document(updatedCategoryModel.categoryDocId)
          .updateData({
        _categoryName: updatedCategoryModel.categoryName,
        _categoryImageRef: url
      }).catchError((error) {
        throw error;
      });
    }else{
      await Firestore.instance
          .collection(category_collection)
          .document(updatedCategoryModel.categoryDocId)
          .updateData({
        _categoryName: updatedCategoryModel.categoryName,
      }).catchError((error) {
        throw error;
      });
    }
    notifyListeners();
  }

  CategoryModel convertToCategoryModel(DocumentSnapshot docu) {
    var doc = docu.data;
    return CategoryModel(
        categoryDocId: docu.documentID,
        categoryName: doc[_categoryName],
        categoryImageRef: doc[_categoryImageRef]);
  }
}
