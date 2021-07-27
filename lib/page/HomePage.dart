import 'dart:developer';

import 'package:budget_front/widget/ArticlesListWidget.dart';
import 'package:budget_front/page/ArticlesPage.dart';
import 'package:budget_front/page/BalancesPage.dart';
import 'package:budget_front/widget/DonutPieChart.dart';
import 'package:budget_front/page/OperationsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/AddArticleWidget.dart';
import '../widget/ArticlesPieCharts.dart';
import '../request/ArticlesRequests.dart';
import '../entity/article.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title});

  @override
  State<MyHomePage> createState() {
    return MyHomePageState(key: key, title: title);
  }
}

class MyHomePageState extends State<MyHomePage> {
  final String title;
  Widget bodyWidget;



  MyHomePageState({Key key, this.title})
  {
    bodyWidget = bodyArticles();
  }


  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan[700],
            ),
            child: Text(
              'Budget menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Articles'),
            onTap: () {
              setState(() {
                bodyWidget = bodyArticles();
              });
              Navigator.pop(context);
            }
          ),
          ListTile(
            leading: Icon(Icons.send_to_mobile),
            title: Text('Operations'),
              onTap: () {
                setState(() {
                  bodyWidget = bodyOperations();
                });

                Navigator.pop(context);
              }
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Balance'),
              onTap: () {
                setState(() {
                  bodyWidget = bodyBalances();
                });
                Navigator.pop(context);
              }
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Cancel'),
            onTap: () {
              // change app state...
              Navigator.pop(context); // close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Chart '),
            onTap: () {
              setState(() {
                bodyWidget = new ArticlesPieCharts();
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget bodyArticles() {
    return ArticlesPage();
  }

  Widget bodyOperations() {
    return OperationsPage();
  }

  Widget bodyBalances() {
    return BalancesPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.cyan[700],
      ),
      drawer: drawer(),
      body: bodyWidget,

    );
  }
}
