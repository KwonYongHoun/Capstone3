import 'package:flutter/material.dart';
import 'package:health/Sin/community.dart';
import 'myhomepage.dart';

//import 'loginpage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'my app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: LoginPage(),
      home: MyHomePage(),
    );
  }
}
