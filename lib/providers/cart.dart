import 'package:flutter/material.dart';
class CartItem {
  String image;
  String name;
  double price;
  int quantity;
  double subTotal;

  CartItem({
    this.image,
    this.name,
    this.price,
    this.quantity,
    this.subTotal
  });
}


class Cart with ChangeNotifier{
  List<CartItem> cartItemList = [];

  void addCartItemToList(CartItem item){
    cartItemList.add(item);
    notifyListeners();
  }
  List<CartItem> getCartItemList(){
    return cartItemList;
  }
  void clearCartItemList(){
    cartItemList = [];
    notifyListeners();
  }


}

