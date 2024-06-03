import 'package:flutter/material.dart';
import '../health.dart'; // Member 클래스가 있는 파일로 경로를 수정해주세요.

class AuthProvider extends ChangeNotifier {
  Member? _loggedInMember;

  void login(Member member) {
    _loggedInMember = member;
    notifyListeners();
  }

  void logout() {
    _loggedInMember = null;
    notifyListeners();
  }

  Member? get loggedInMember => _loggedInMember;

  void setLoggedInMember(Member member) {
    _loggedInMember = member;
    notifyListeners();
  }

//비밀번호

  String _enteredPassword = '';

  String get enteredPassword => _enteredPassword;

  void setAuthInfo(String id, String password) {
    _enteredPassword = password;
    notifyListeners();
  }
}
