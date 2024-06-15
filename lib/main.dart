import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Sin/AuthProvider.dart';
import 'Park/loginpage.dart';
import 'Park/myhomepage.dart';
import 'Sin/WPage.dart';
import 'Park/findid.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: FindId()));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [routeObserver],
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => MyHomePage(),
        '/write': (context) => WritePage(),
      },
    );
  }
}
