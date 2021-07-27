import 'dart:async';
import 'dart:developer';

import 'package:budget_front/widget/BalanceListWidget.dart';
import 'package:budget_front/widget/OperationsListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/Balance.dart';
import '../entity/Operation.dart';

import 'package:http/http.dart' as http;

import '../request/OperationsRequests.dart';

class BalanceInfoWidget extends StatefulWidget {
  Balance balance;

  BalanceInfoWidget({this.balance}){}

  @override
  BalanceInfoWidgetState createState() => BalanceInfoWidgetState(balance: balance);
}

class BalanceInfoWidgetState extends State<BalanceInfoWidget> {
  Balance balance;
  BalanceInfoWidgetState({this.balance}){
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[700],
      child: Column(
        children: [
          Padding( padding: EdgeInsets.all(10), child:
            Text("Balance", style: TextStyle(decoration:TextDecoration.none, fontSize: 18, color: Colors.white))
          ),
          BalanceItem(balance: balance,),
          Padding( padding: EdgeInsets.all(10), child:
          Text("Operations", style: TextStyle(decoration:TextDecoration.none, fontSize: 18, color: Colors.white))
          ),
          Expanded(
              child:
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: BalanceOperationsStreamBuilder(key: UniqueKey(), balance_id: balance.id,)
              )
          )

          /*Container(
            height: 500,
            color: Colors.grey[300],
            child:
              BalanceOperationsStreamBuilder(key: UniqueKey(), balance_id: balance.id,)
        )*/
        ],
      ),
    )
      ;
  }
}

class BalanceOperationsStreamBuilder extends StatefulWidget {
  int balance_id;
  BalanceOperationsStreamBuilder({Key key, this.balance_id}): super(key: key){
  }
  @override
  BalanceOperationsStreamBuilderState createState() {
    return new BalanceOperationsStreamBuilderState(balance_id: balance_id);
  }

}
class BalanceOperationsStreamBuilderState extends State<BalanceOperationsStreamBuilder> {
  final operationsStream = StreamController<List<Operation>>();
  int balance_id;

  BalanceOperationsStreamBuilderState({this.balance_id});

  void refreshOperations() {
    log('refresh operations');
    Future<List<Operation>> res = fetchOperationsOfBalance(http.Client(), balance_id);
    res.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          operationsStream.sink.add(value);
        });
      }
    });
  }
  @override
  void initState() {
    refreshOperations();
  }
  @override
  void dispose() {
    super.dispose();
    operationsStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: operationsStream.stream,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return OperationsListWidget(key: UniqueKey(), operations: snapshot.data);
        }
    );
  }

}
