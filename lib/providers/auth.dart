import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppy/exceptions/http_exceptions.dart';
import '../helpers/constants.dart';

class Auth extends ChangeNotifier {
  String? _token;
  String? userId;
  DateTime? expiryDate;
  Timer? _authTimer;
  bool get isAuth => token != null;

  String? get token {
    if (_token != null &&
        expiryDate != null &&
        expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> authenticate(
      String email, String password, String actionWord) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$actionWord?key=$apiKey";

      final response = await http.post(Uri.parse(url), body: {
        "email": email,
        "password": password,
        "returnSecureToken": "true",
      });

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(message: responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      userId = responseData["localId"];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));

      notifyListeners();
      _autoLogout();
      await saveLocaly();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  void logout() async {
    userId = null;
    _token = null;
    expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await clearDataLocaly();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return true;
    }
    final extractedData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryDateStored = DateTime.parse(extractedData["expiryDate"]!);
    if (expiryDateStored.isBefore(DateTime.now())) {
      return false;
    }
    expiryDate = expiryDateStored;
    userId = extractedData["userId"];
    _token = extractedData["token"];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> saveLocaly() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': userId,
      'expiryDate': expiryDate!.toIso8601String()
    });

    prefs.setString('userData', userData);
  }

  Future<void> clearDataLocaly() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
