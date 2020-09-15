
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'collection_names.dart';


class UserModel {
  String userDocId;
//  String email;
  int loyaltyPoints;

  UserModel(
      {
        @required this.userDocId,
//      @required this.email,
        @required this.loyaltyPoints});
}


class User with ChangeNotifier{

  String _email = 'email';
  String _loyaltypoints = 'loyaltypoints';

  UserModel _userProfile ;
  UserModel get userProfile => _userProfile;

  Future<void> getCurrentUser(String currentUserId) async {
    await Firestore.instance.collection(users_collection).document(currentUserId).get().then((DocumentSnapshot value){
      print('current user' + value.documentID);
      _userProfile = UserModel(userDocId: value.documentID, loyaltyPoints: value.data[_loyaltypoints]);
      print(_userProfile.userDocId+ 'user');
    }).catchError((error) async{
      await Firestore.instance.collection(users_collection).document(currentUserId).setData({
        _loyaltypoints: 0
      });
      _userProfile = UserModel(userDocId: currentUserId, loyaltyPoints: 0);
    });

    notifyListeners();
  }

  UserModel convertToUserModel(DocumentSnapshot docu) {
    var doc = docu.data;
    return UserModel(
//      email: doc[_email],
      userDocId: docu.documentID,
      loyaltyPoints: doc[_loyaltypoints]
    );
  }



}