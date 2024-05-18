import 'package:flutter/material.dart';
import 'myhomepage.dart';
import 'findid.dart';
import 'findpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool _isPasswordVisible = false;
  bool _isAutoLogin = false; // 자동 로그인 상태 변수

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = MediaQuery.of(context).size.width - 110;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(55.0),
        child: Stack(
          children: [
            // 이미지를 원하는 위치에 배치합니다.
            Positioned(
              top: 20, // Adjust this value based on your layout needs
              right: 0, // Adjust this value to align with the 'Login' text
              child: Image.asset('../assets/loginskon.png', width: 200),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                Text(
                  '초기 ID : 회원번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  '초기 비밀번호 : 회원번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: idController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'ID',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    filled: true, // 배경색 채우기 활성화
                    fillColor: Colors.white, // 배경색을 하얀색으로 설정
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: textFieldWidth,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.black),
                    obscureText: !_isPasswordVisible, // 비밀번호 표시 형식 설정
                    decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Color.fromARGB(
                            255, 214, 214, 214), // 체크되지 않은 상태의 색상
                        checkboxTheme: CheckboxThemeData(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green; // 체크된 상태의 색상
                              }
                              return Color.fromARGB(
                                  255, 214, 214, 214); // 체크되지 않은 상태의 색상
                            },
                          ),
                          checkColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white; // 체크된 상태의 체크 표시 색상
                              }
                              return const Color.fromARGB(
                                  255, 209, 209, 209); // 체크되지 않은 상태의 체크 표시 색상
                            },
                          ),
                        ),
                      ),
                      child: Checkbox(
                        value: _isAutoLogin,
                        onChanged: (newValue) {
                          setState(() {
                            _isAutoLogin = newValue!;
                          });
                        },
                      ),
                    ),
                    Text("자동 로그인"),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                      child: Text(
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
                          MaterialPageRoute(
                              builder: (context) => FindPassword()),
                        );
                      },
                      child: Text(
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
          ],
        ),
      ),
    );
  }
}
