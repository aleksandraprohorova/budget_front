import 'dart:developer';

import 'package:budget_front/request/OperationsRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../request/ArticlesRequests.dart';
import '../entity/Operation.dart';
import '../entity/article.dart';

class ArticlesDropDownList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class OperationItem extends StatefulWidget {
  Operation operation;
  Future<List<Article>> articles;

  OperationItem({this.operation, this.articles}){}

  @override
  OperationItemState createState() => OperationItemState(operation: operation, dropdownListArticles: articles);
}

class OperationItemState extends State<OperationItem> {
  Operation operation;

  final TextEditingController _controllerDebit = TextEditingController();
  FocusNode _focusNodeDebit = FocusNode();

  final TextEditingController _controllerCredit = TextEditingController();
  FocusNode _focusNodeCredit = FocusNode();

  FocusNode _focusNodeBackground = FocusNode();

  DateTime selectedDate;
  TimeOfDay selectedTime;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  OperationItemState({this.operation, this.dropdownListArticles}) {
    selectedArticle = operation.article;
    selectedDate = operation.createDate;
    selectedTime = new TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
    selectedDate = selectedDate.subtract(Duration(
      hours: selectedDate.hour,
      minutes: selectedDate.minute
    ));
  }
  @override
  void initState() {
    _controllerCredit.value = _controllerCredit.value.copyWith(
        text: '- ${operation.credit.toString()}');
    _controllerDebit.value = _controllerDebit.value.copyWith(
        text: '+ ${operation.debit.toString()}');


    _controllerDebit.addListener(() {
      String text = _controllerDebit.text.toLowerCase();
      if (text.length < 2) {
        text = '+ ';
      }
      _controllerDebit.value = _controllerDebit.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _controllerCredit.addListener(() {
      final String text = _controllerCredit.text.toLowerCase();
      _controllerCredit.value = _controllerCredit.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    _focusNodeDebit.addListener(() {
      if(!_focusNodeDebit.hasFocus)
      {
        String tmp = _controllerDebit.text.substring(2, _controllerDebit.text.length);
        final newOperation = new Operation(
            id: operation.id,
            createDate: operation.createDate,
            article: operation.article,
            debit: double.parse(tmp),
            credit: operation.credit);
        Future<bool> res = addOperation(http.Client(), AddOperationRequest(operation: newOperation));
        //Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
        res.then((value) {
          if (value) {
            operation.debit = double.parse(_controllerDebit.text.substring(2, _controllerDebit.text.length));
          }
          else {
            _controllerDebit.value = _controllerDebit.value.copyWith(
              text: operation.debit.toString(),
              selection:
              TextSelection(baseOffset: operation.debit.toString().length, extentOffset: operation.debit.toString().length),
              composing: TextRange.empty,
            );
          }
        });
      }
    });

    _focusNodeCredit.addListener(() {
      if(!_focusNodeCredit.hasFocus)
      {
        String tmp = _controllerCredit.text.substring(2, _controllerCredit.text.length);
        final newOperation = new Operation(
            id: operation.id,
            createDate: operation.createDate,
            article: operation.article,
            debit: operation.debit,
            credit: double.parse(tmp));
        Future<bool> res = addOperation(http.Client(), AddOperationRequest(operation: newOperation));
        //Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
        res.then((value) {
          if (value) {
            operation.credit = double.parse(_controllerCredit.text.substring(2, _controllerCredit.text.length));
          }
          else {
            _controllerCredit.value = _controllerCredit.value.copyWith(
              text: operation.credit.toString(),
              selection:
              TextSelection(baseOffset: operation.credit.toString().length, extentOffset: operation.credit.toString().length),
              composing: TextRange.empty,
            );
          }
        });
      }
    });

    //dropdownListArticles = fetchArticles(http.Client());
    dropdownListArticles.then((value) => selectedArticle = value.firstWhere((element) => element.name == operation.article.name));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controllerDebit.dispose();
    _focusNodeDebit.dispose();

    _controllerCredit.dispose();
    _focusNodeCredit.dispose();

    _focusNodeBackground.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
  }
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        log(selectedTime.format(context));
        /*selectedDate.subtract(
            Duration(
                hours: selectedDate.hour,
                minutes: selectedDate.minute,
                seconds: selectedDate.second,
                milliseconds: selectedDate.millisecond,
                microseconds: selectedDate.microsecond
            ));*/
        log(selectedDate.toString());
        selectedDate = selectedDate.add(
            Duration(
                hours: selectedTime.hour,
                minutes: selectedTime.minute
            )
        );
        log(selectedDate.toString());
        Operation newOperation = new Operation(
          id: operation.id,
          createDate: selectedDate,
          article: operation.article,
          debit: operation.debit,
          credit: operation.credit
        );
        Future<bool> res = addOperation(http.Client(), AddOperationRequest(operation: newOperation));
        //Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
        res.then((value) {
          if (value) {
            operation.createDate = selectedDate;
          }
        });
      });
  }

  Article selectedArticle;

  Future<List<Article>> dropdownListArticles;
  bool fetchedArticles = false;

  Future<List<Article>> getArticles() {
    /*if (!fetchedArticles) {
      fetchedArticles = true;
      dropdownListArticles = fetchArticles(http.Client());
      if (dropdownListArticles == null) log('still null');
      dropdownListArticles.then((value) => selectedArticle = value.firstWhere((element) => element.name == operation.article.name));
    }*/
    return dropdownListArticles;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: Colors.lightBlue[50],
        margin: EdgeInsets.all(5),
        child: InkWell(
          //splashColor: Colors.blue.withAlpha(30),
          splashColor: Colors.lightBlue[50],
          focusNode: _focusNodeBackground,
          onTap: () {
            print('Card tapped.');
            _focusNodeBackground.requestFocus();
            _focusNodeBackground.unfocus();
          },
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  Column(
                    children: [
                      Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        child: ElevatedButton(
                            onPressed: (){
                              _selectDate(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              onPrimary: Colors.black, // foreground
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.white)
                              ),
                            ),
                            child: Text('${formatter.format(selectedDate)}, ${selectedTime.format(context)}', style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                              decorationColor: Colors.black,
                            ),)
                        ),
                      ),
                      Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        child: FutureBuilder<List<Article>>(
                            future: getArticles(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                              return DropdownButton<Article>(
                                value: selectedArticle,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.cyan),
                                underline: Container(
                                  height: 2,
                                  color: Colors.cyan[700],
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    log('onChanged');
                                    selectedArticle = newValue;
                                    Operation newOperation = new Operation(
                                        id: operation.id,
                                        createDate: operation.createDate,
                                        article: selectedArticle,
                                        debit: operation.debit,
                                        credit: operation.credit
                                    );
                                    Future<bool> res = addOperation(http.Client(), AddOperationRequest(operation: newOperation));
                                    //Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
                                    res.then((value) {
                                      if (value) {
                                        operation.article = selectedArticle;
                                      }
                                    });
                                  });
                                },
                                hint: Text("choose article name", style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  decorationColor: Colors.black,
                                ),),
                                items: snapshot.data.map<DropdownMenuItem<Article>>((Article value) {
                                  return new DropdownMenuItem<Article>(
                                    value: value,
                                    child: new Text(value.name, style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18.0,
                                      decorationColor: Colors.black,
                                    ),),
                                  );
                                }).toList(),
                              );
                            }
                        ),
                      ),
                    ],),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _controllerDebit,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18.0,
                            //decorationColor: Colors.white,
                            backgroundColor: Colors.white
                        ),
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.blue,
                        maxLines: null,
                        //backgroundCursorColor: Colors.black,
                        //autofocus: true,
                        focusNode: _focusNodeDebit,
                        decoration:
                        InputDecoration(
                           border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _controllerCredit,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                            //decorationColor: Colors.white,
                            backgroundColor: Colors.white
                        ),
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.blue,
                        maxLines: null,
                        //backgroundCursorColor: Colors.black,
                        //autofocus: true,
                        focusNode: _focusNodeCredit,
                        decoration:
                        InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],)
                )

              ],),
          )
        )
    );
  }
}

class OperationsListWidget extends StatefulWidget {
  List<Operation> operations;
  OperationsListWidget({Key key, this.operations}): super(key: key);

  @override
  OperationsListWidgetState createState() {
    return OperationsListWidgetState(operations: operations);
  }
}

class OperationsListWidgetState extends State<OperationsListWidget>
{
  List<Operation> operations;
  Future<List<Article>> articles;

  OperationsListWidgetState({this.operations}) {
  }
  @override
  void initState() {
    articles = fetchArticles(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: operations.length,
        itemBuilder: (BuildContext context, int index) {
          final item = operations[index];
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  operations.removeAt(index);
                  Future<bool> res = deleteOperation(http.Client(), item.id);
                  res.then((value) {
                    if (value) {

                    }
                  });

                });
              },
              child: OperationItem(operation: operations[index], articles: articles,));
          //return ArticleItem(article: articles[index],);
        }

    );
  }
}
