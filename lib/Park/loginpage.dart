import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../health.dart';
import '../Sin/AuthProvider.dart';
import 'myhomepage.dart';
import 'findid.dart';
import 'findpassword.dart';
import '../Kwon/AdminMain.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool autoLogin = false; // 자동 로그인 상태
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _loadUserPreferences();
  }

  Future<void> _initializeFirebase() async {
    await DatabaseHelper.initialize();
  }

  Future<void> _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLoginPref = prefs.getBool('autoLogin') ?? false;
    if (autoLoginPref) {
      String userId = prefs.getString('userId') ?? '';
      String userPassword = prefs.getString('userPassword') ?? '';
      _login(userId, userPassword, autoLoginPref);
    }
    setState(() {
      autoLogin = autoLoginPref;
    });
  }

  Future<void> _updateUserPreferences(String userId, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', autoLogin);
    if (autoLogin) {
      await prefs.setString('userId', userId);
      await prefs.setString('userPassword', password);
    } else {
      await prefs.remove('userId');
      await prefs.remove('userPassword');
    }
  }

  void _login(String userId, String password, bool autoLoginEnabled) async {
    if (userId == 'admin' && password == 'master') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminModeHomePage()),
      );
    } else {
      // Query the database for a member with the entered ID and password
      List<Member> members = await DatabaseHelper.IDCheck(userId, password);
      if (members.isNotEmpty) {
        Member member = members.first;
        Provider.of<AuthProvider>(context, listen: false).login(member);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('memberNumber', member.memberNumber.toString());
        await prefs.setString('memberState', member.memberState);

        if (autoLoginEnabled) {
          await _updateUserPreferences(userId, password);
        }

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          errorMessage = '아이디 또는 비밀번호가 올바르지 않습니다.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/로그인.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(55.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      '초기 ID : 회원번호',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      '초기 비밀번호 : 전화번호',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 112, 203, 245), width: 3.0),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PASSWORD',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: autoLogin,
                    onChanged: (bool? value) {
                      setState(() {
                        autoLogin = value!;
                      });
                    },
                    activeColor: Colors.green, // 선택된 상태의 배경색
                    checkColor: Colors.white, // 체크 표시의 색상
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected))
                        return Colors.green; // 선택 상태일 때의 배경색
                      return Colors.grey; // 기본 배경색
                    }),
                  ),
                  const Text('자동 로그인'),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _login(idController.text, passwordController.text, autoLogin);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindId()),
                      );
                    },
                    child: const Text(
                      '회원번호 찾기',
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 138, 138),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindPassword()),
                      );
                    },
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 138, 138),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
