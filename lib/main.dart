import 'package:budget_front/page/AuthorizationPage.dart';
import 'package:flutter/material.dart';
import 'page/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Budget';

    return MaterialApp(
      title: appTitle,
      //home: MyHomePage(title: appTitle),
      home: AuthorizationPage()
    );
  }
}
