import 'package:flutter/material.dart';
class LoginFormPorvider extends ChangeNotifier {
  
  GlobalKey<FormState> fromKey = new GlobalKey<FormState>();

  String email = '';
  String pasword = '';
  bool _isLoding = false;

  bool get isLoading => _isLoding;
  
  set isLoading (bool value ) {
    _isLoding = value;
    notifyListeners();
  }

  bool isValidForm() {

    return fromKey.currentState?.validate() ?? false;
  }

  
}