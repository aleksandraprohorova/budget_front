import 'dart:developer';

import 'package:budget_front/widget/BalanceInfoWidget.dart';
import 'package:budget_front/request/BalancesRequests.dart';
import 'package:budget_front/request/OperationsRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../request/ArticlesRequests.dart';
import '../entity/Balance.dart';
import '../entity/Operation.dart';
import '../entity/article.dart';

class BalanceItem extends StatefulWidget {
  Balance balance;

  BalanceItem({this.balance}){}

  @override
  BalanceItemState createState() => BalanceItemState(balance: balance);
}

class BalanceItemState extends State<BalanceItem> {
  Balance balance;

  final TextEditingController _controllerDebit = TextEditingController();
  FocusNode _focusNodeDebit = FocusNode();

  final TextEditingController _controllerCredit = TextEditingController();
  FocusNode _focusNodeCredit = FocusNode();

  final TextEditingController _controllerAmount = TextEditingController();
  FocusNode _focusNodeAmount = FocusNode();

  FocusNode _focusNodeBackground = FocusNode();

  DateTime selectedDate;
  TimeOfDay selectedTime;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  BalanceItemState({this.balance}) {
    selectedDate = balance.createDate;
    selectedTime = new TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
    selectedDate = selectedDate.subtract(Duration(
        hours: selectedDate.hour,
        minutes: selectedDate.minute
    ));
  }
  @override
  void initState() {
    _controllerCredit.value = _controllerCredit.value.copyWith(
        text: '- ${balance.credit.toString()}');
    _controllerDebit.value = _controllerDebit.value.copyWith(
        text: '+ ${balance.debit.toString()}');
    _controllerAmount.value = _controllerAmount.value.copyWith(
        text: '+ ${balance.amount.toString()}');


    /*_controllerDebit.addListener(() {
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
      String text = _controllerCredit.text.toLowerCase();
      if (text.length < 2) {
        text = '- ';
      }
      _controllerCredit.value = _controllerCredit.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    _controllerAmount.addListener(() {
      String text = _controllerCredit.text.toLowerCase();
      if (text.length < 2) {
        text = '+ ';
      }
      _controllerAmount.value = _controllerAmount.value.copyWith(
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
        final newBalance = new Balance(
            id: balance.id,
            createDate: balance.createDate,
            amount: balance.amount,
            debit: double.parse(tmp),
            credit: balance.credit);
      }
    });

    _focusNodeCredit.addListener(() {
      if(!_focusNodeCredit.hasFocus)
      {
        String tmp = _controllerCredit.text.substring(2, _controllerCredit.text.length);
        final newBalance = new Balance(
            id: balance.id,
            createDate: balance.createDate,
            amount: balance.amount,
            debit: balance.debit,
            credit: double.parse(tmp));
      }
    });*/

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controllerDebit.dispose();
    _focusNodeDebit.dispose();

    _controllerCredit.dispose();
    _focusNodeCredit.dispose();

    _controllerAmount.dispose();
    _focusNodeAmount.dispose();


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

        log(selectedDate.toString());
        selectedDate = selectedDate.add(
            Duration(
                hours: selectedTime.hour,
                minutes: selectedTime.minute
            )
        );
        log(selectedDate.toString());
        /*Operation newOperation = new Operation(
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
        });*/
      });
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => BalanceInfoWidget(balance: balance)),);
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
                              //_selectDate(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              onPrimary: Colors.black, // foreground
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.white)
                              ),
                            ),
                            child: Text('${formatter.format(selectedDate)}', style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                              decorationColor: Colors.black,
                            ),)
                        ),
                      ),
                      Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        child: TextField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          controller: _controllerAmount,
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
                          focusNode: _focusNodeAmount,
                          decoration:
                          InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        child: TextField(
                          enabled: false,
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
                          enabled: false,
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

class BalanceListWidget extends StatefulWidget {
  List<Balance> balances;
  BalanceListWidget({Key key, this.balances}): super(key: key);

  @override
  BalanceListWidgetState createState() {
    return BalanceListWidgetState(balances: balances);
  }
}

class BalanceListWidgetState extends State<BalanceListWidget>
{
  List<Balance> balances;

  BalanceListWidgetState({this.balances}) {
  }
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: balances.length,
        itemBuilder: (BuildContext context, int index) {
          final item = balances[index];
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  balances.removeAt(index);
                  Future<bool> res = deleteBalance(http.Client(), item.id);
                  res.then((value) {
                    if (value) {

                    }
                  });

                });
              },
              child: BalanceItem(balance: balances[index]));
          //return ArticleItem(article: articles[index],);
        }

    );
  }
}
