import 'package:flutter/material.dart';
import 'myhomepage.dart';
import 'findid.dart';
import 'findpassword.dart';
import '../member.dart';
import '../Kwon/AdminMain.dart';

//입력된 아이디 들고있는 변수
String EnteredID = '';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(55.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
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
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'ID',
                labelStyle: TextStyle(color: Colors.grey),
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
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                labelStyle: TextStyle(color: Colors.grey),
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
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Retrieve entered ID and password
                String enteredId = idController.text;
                String enteredPassword = passwordController.text;

                //관리자모드 실행 : Id admin / 비밀번호 master
                if (enteredId == 'admin' && enteredPassword == 'master') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminModeHomePage()),
                  );
                }

                if (enteredId == '1' && enteredPassword == '1') {
                  EnteredID = enteredId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }

                // Query the database for a member with the entered ID
                List<Member> members =
                    await DatabaseHelper.searchMembers(enteredId);

                if (members.isNotEmpty) {
                  Member member = members.first;
                  // Compare the retrieved member's password with the entered password
                  if (member.password.toString() == enteredPassword) {
                    // Login successful
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  } else {
                    // Password does not match
                    setState(() {
                      errorMessage = '비밀번호가 올바르지 않습니다.';
                    });
                  }
                } else {
                  // Member with the entered ID not found
                  setState(() {
                    errorMessage = '해당 ID가 존재하지 않습니다.';
                  });
                }
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // FindIdPage로 이동
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
                    // FindPassword로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindPassword()),
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
      ),
    );
  }
}
