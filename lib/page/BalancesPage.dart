import 'dart:async';
import 'dart:developer';

import 'package:budget_front/widget/AddBalanceWidget.dart';
import 'package:budget_front/widget/BalanceListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/Balance.dart';
import '../request/BalancesRequests.dart';

import 'package:http/http.dart' as http;

class BalancesStreamBuilder extends StatefulWidget {
  BalancesStreamBuilderState state = new BalancesStreamBuilderState();
  BalancesStreamBuilder({Key key}): super(key: key);
  @override
  BalancesStreamBuilderState createState() {
    return state;
  }
  void refreshBalances() {
    state.refreshBalances();
  }

}
class BalancesStreamBuilderState extends State<BalancesStreamBuilder> {
  final balancesStream = StreamController<List<Balance>>();

  void refreshBalances() {
    log('refresh balances');
    Future<List<Balance>> res = fetchBalances(http.Client());
    res.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          balancesStream.sink.add(value);
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    balancesStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: balancesStream.stream,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          /*if (snapshot.connectionState == ConnectionState.done) {
          }*/
          /*if (snapshot.connectionState == ConnectionState.active) {
            return ArticlesListWidget(articles: snapshot.data);
          }
          return Center(child: CircularProgressIndicator());*/
          return BalanceListWidget(key: UniqueKey(), balances: snapshot.data);
        }
    );
  }

}

class BalancesPage extends StatefulWidget {

  @override
  BalancesPageState createState() {
    return BalancesPageState();
  }
}

class BalancesPageState extends State<BalancesPage> {
  List<Widget> widgets = [];
  bool isPressed;
  List<Balance> balances;
  BalancesStreamBuilder balancesStreamBuilder = new BalancesStreamBuilder(key: UniqueKey());

  BalancesPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: widgets,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: !isPressed
              ? () => addButtonPressed()
              : null,
          label: const Text('Add balance'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.cyan[700],
        )
    );
  }
  @override
  void initState() {
    super.initState();
    widgets.add(balancesStreamBuilder);
    balancesStreamBuilder.refreshBalances();
    isPressed = false;
  }

  void addButtonPressed() {
    setState(() {
      log('pressed add button');
      isPressed = true;
      widgets.add(Center(child: AddBalanceWidget(callback: () {
        setState(() {
          widgets.removeLast();
          balancesStreamBuilder.refreshBalances();
          isPressed = false;
        });
      })
      )
      );
    });
  }

}
