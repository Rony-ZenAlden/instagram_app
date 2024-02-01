import 'package:flutter/material.dart';
import 'package:instagram_app/Controllers/auth_controller.dart';
import 'package:instagram_app/Models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthController _authMethods = AuthController();

  User? get getUser {
    return _user;
  }

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}