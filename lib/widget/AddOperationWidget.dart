import 'dart:developer';
import 'dart:html';

import 'package:budget_front/request/OperationsRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../request/ArticlesRequests.dart';
import '../entity/Operation.dart';
import '../entity/article.dart';

import 'package:http/http.dart' as http;

class AddOperationWidget extends StatefulWidget {
  final Function callback;

  AddOperationWidget({this.callback}){}

  @override
  AddOperationWidgetState createState() => AddOperationWidgetState(callback: callback);
}

class AddOperationWidgetState extends State<AddOperationWidget> {

  final TextEditingController _controllerDebit = TextEditingController();
  FocusNode _focusNodeDebit = FocusNode();

  final TextEditingController _controllerCredit = TextEditingController();
  FocusNode _focusNodeCredit = FocusNode();

  final Function callback;

  Future<List<Article>> articles;

  AddOperationWidgetState({this.callback}) {
    articles = fetchArticles(http.Client());
  }

  @override
  void initState() {
    super.initState();
    articles.then((value) => selectedArticle = value.first);
    //selectedArticle = articles.first;
    //fetchArticles(http.Client()).then((value) => articles = value);

    _controllerDebit.addListener(() {
      final String text = _controllerDebit.text.toLowerCase();
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
  }

  @override
  void dispose() {
    super.dispose();

    _controllerDebit.dispose();
    _focusNodeDebit.dispose();

    _controllerCredit.dispose();
    _focusNodeCredit.dispose();
  }
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Article selectedArticle;
  //List<Article> articles = [new Article(name:"article1",id: 1), new Article(name:"article2",id: 2)];

  Future<List<Article>> getArticles() {
    final res = fetchArticles(http.Client());
    res.then((value) => selectedArticle = value.first);
    return res;
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
        _selectTime(context);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      child: Center(child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: Colors.cyan[700],
        margin: EdgeInsets.symmetric(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("New operation", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  decorationColor: Colors.white,
                ),)
            ),
            Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
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
                              future: articles,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                return DropdownButton<Article>(
                                  value: selectedArticle,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      log('onChanged');
                                      selectedArticle = newValue;
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
                          )
                            //Text('${articles[index].name}', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),)),
                          ,
                        ],),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(children: [
                          Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                            child: TextField(
                            textAlign: TextAlign.start,
                            controller: _controllerDebit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              //decorationColor: Colors.white,
                              backgroundColor: Colors.white
                            ),
                            decoration:
                            InputDecoration(
                                hintText: "debit",border: InputBorder.none,
                                hintStyle:  TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  backgroundColor: Colors.white,

                              //decorationColor: Colors.white,
                            )),
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.blue,
                            maxLines: null,
                            //backgroundCursorColor: Colors.black,
                            //autofocus: true,
                            focusNode: _focusNodeDebit,
                          ),),
                          Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                            child: TextField(
                            textAlign: TextAlign.start,
                            controller: _controllerCredit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              decorationColor: Colors.white,
                            ),
                              decoration:
                              InputDecoration(
                                  hintText: "credit",
                                  border: InputBorder.none,
                                  hintStyle:  TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                    backgroundColor: Colors.white,

                                    //decorationColor: Colors.white,
                                  )),
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.blue,
                            maxLines: null,
                            //backgroundCursorColor: Colors.black,
                            //autofocus: true,
                            focusNode: _focusNodeCredit,
                          ),)
                        ],)
                    )

                  ],),
                )
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: (){
                      selectedDate = selectedDate.add(
                          Duration(
                              hours: selectedTime.hour,
                              minutes: selectedTime.minute
                          )
                      );
                      Operation operation = new Operation(
                          debit: double.parse(_controllerDebit.text),
                          credit: double.parse(_controllerCredit.text),
                          createDate: selectedDate,
                          article: selectedArticle
                      );
                      final res = addOperation(http.Client(), new AddOperationRequest(operation: operation));
                      res.then((value) => callback());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[50], // background
                      onPrimary: Colors.black, // foreground
                    ),
                    child: Text('ok', style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      decorationColor: Colors.black,
                    ),)
                ),
                ElevatedButton(
                    onPressed: (){
                      callback();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue[50], // background
                      onPrimary: Colors.black, // foreground
                    ),
                    child: Text('cancel', style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      decorationColor: Colors.black,
                    ),))
              ],
            )
          ],
        ),
      )
      ),
    );
  }
}
