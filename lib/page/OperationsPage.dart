import 'dart:async';
import 'dart:developer';

import 'package:budget_front/widget/AddOperationWidget.dart';
import 'package:budget_front/request/OperationsRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/Operation.dart';

import 'package:http/http.dart' as http;

import '../widget/OperationsListWidget.dart';

class OperationsStreamBuilder extends StatefulWidget {
  OperationsStreamBuilderState state = new OperationsStreamBuilderState();
  OperationsStreamBuilder({Key key}): super(key: key);
  @override
  OperationsStreamBuilderState createState() {
    return state;
  }
  void refreshOperations() {
    state.refreshOperations();
  }

}
class OperationsStreamBuilderState extends State<OperationsStreamBuilder> {
  final operationsStream = StreamController<List<Operation>>();

  void refreshOperations() {
    log('refresh operations');
    Future<List<Operation>> res = fetchOperations(http.Client());
    res.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          operationsStream.sink.add(value);
        });
      }
    });
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
          /*if (snapshot.connectionState == ConnectionState.done) {
          }*/
          /*if (snapshot.connectionState == ConnectionState.active) {
            return ArticlesListWidget(articles: snapshot.data);
          }
          return Center(child: CircularProgressIndicator());*/
          return OperationsListWidget(key: UniqueKey(), operations: snapshot.data);
        }
    );
  }

}

class OperationsPage extends StatefulWidget {

  @override
  OperationsPageState createState() {
    return OperationsPageState();
  }
}

class OperationsPageState extends State<OperationsPage> {
  List<Widget> widgets = [];
  bool isPressed;
  List<Operation> articles;
  OperationsStreamBuilder operationsStreamBuilder = new OperationsStreamBuilder(key: UniqueKey());

  OperationsPageState();

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
          label: const Text('Add operation'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.cyan[700],
        )
    );
  }
  @override
  void initState() {
    super.initState();
    widgets.add(operationsStreamBuilder);
    operationsStreamBuilder.refreshOperations();
    isPressed = false;
  }

  void addButtonPressed() {
    setState(() {
      log('pressed add button');
      isPressed = true;
      widgets.add(Center(child: AddOperationWidget(callback: () {
        setState(() {
          widgets.removeLast();
          operationsStreamBuilder.refreshOperations();
          isPressed = false;
        });
      })
      )
      );
    });
  }

}
