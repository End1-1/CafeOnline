import 'package:cafe_online/consts.dart' as Const;
import 'package:cafe_online/dashboard/screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jazzve Online',
      debugShowCheckedModeBanner: false,
      navigatorKey: Const.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(title: 'Jazzve Online'),
    );
  }
}


