import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';

class ProductFormProvder extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Product product;

  ProductFormProvder (this.product) { }

  updateAvailable(bool value){
    this.product.available = value;
    notifyListeners();
  }

  bool isValiForm() {
    return formKey.currentState.validate() ?? false;
  }
}