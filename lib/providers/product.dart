
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';import 'dart:io';

import 'collection_names.dart';

class ProductModel {
  String productDocId;
  String productName;
  String productPrice;
  String productDescription;
  String productImageRef;

  ProductModel(
      {@required this.productPrice,
      @required this.productName,
      @required this.productDocId,
        @required this.productDescription,
      @required this.productImageRef});
}

class Product with ChangeNotifier {
  ///naming conventions for store model for firebase
  String _productName = "productName";
  String _productPrice = "productPrice";
  String _productDescription = 'productDescription';
  String _productImageRef = "productImage";

  ProductModel _storeProfile;

  ProductModel get storeProfile => _storeProfile;

  Future<void> addNewProduct(
      {@required ProductModel productModel,
      @required File image,
      @required String categoryDocId}) async {
    final ref =
        FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+ ".jpg");
    await ref.putFile(image).onComplete;

    final url = await ref.getDownloadURL();

    await Firestore.instance
        .collection(category_collection)
        .document(categoryDocId)
        .collection(products_collection)
        .add({
      _productName: productModel.productName,
      _productPrice: productModel.productPrice,
      _productDescription: productModel.productDescription,
      _productImageRef: url
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  Future<void> updateProduct(
      {@required ProductModel updatedProductModel,
      @required categoryDocId,File image}) async {

    if (image != null){
      final ref =
      FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+ ".jpg");
      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection(category_collection)
          .document(categoryDocId)
          .collection(products_collection)
          .document(updatedProductModel.productDocId)
          .updateData({
        _productName: updatedProductModel.productName,
        _productPrice: updatedProductModel.productPrice,
        _productDescription: updatedProductModel.productDescription,
        _productImageRef: url
      }).catchError((error) {
        throw error;
      });
    }else{
      await Firestore.instance
          .collection(category_collection)
          .document(categoryDocId)
          .collection(products_collection)
          .document(updatedProductModel.productDocId)
          .updateData({
        _productName: updatedProductModel.productName,
        _productPrice: updatedProductModel.productPrice,
        _productDescription: updatedProductModel.productDescription
      }).catchError((error) {
        throw error;
      });
    }
    notifyListeners();
  }


  ProductModel convertToProductModel(DocumentSnapshot docu) {
    var doc = docu.data;
    return ProductModel(
        productDocId: docu.documentID,
        productName: doc[_productName],
        productPrice: doc[_productPrice],
        productImageRef: doc[_productImageRef],
        productDescription: doc[_productDescription]
    );
  }
}
