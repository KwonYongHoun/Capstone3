import 'package:flutter/material.dart';
import 'package:health/Park/main.dart';

import 'Sin/Commu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  runApp(MyApp());
}
