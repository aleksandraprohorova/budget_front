import 'package:budget_front/request/BalancesRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class AddBalanceWidget extends StatefulWidget {
  final Function callback;

  AddBalanceWidget({this.callback});

  @override
  AddBalanceWidgetState createState() => AddBalanceWidgetState(callback: callback);
}

class AddBalanceWidgetState extends State<AddBalanceWidget> {
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final Function callback;

  AddBalanceWidgetState({this.callback});

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateStart,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateStart)
      setState(() {
        dateStart = picked;
      });
  }
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateEnd,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateEnd)
      setState(() {
        dateEnd = picked;
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
                child: Text("Form new balance", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  decorationColor: Colors.white,
                ),)
            ),

            Row(
              children: [
                Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                  child: ElevatedButton(
                      onPressed: (){
                        _selectStartDate(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // background
                        onPrimary: Colors.black, // foreground
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.white)
                        ),
                      ),
                      child: Text('${formatter.format(dateStart)}', style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        decorationColor: Colors.black,
                      ),)
                  ),
                ),
                Container(width: 200, height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                  child: ElevatedButton(
                      onPressed: (){
                        _selectEndDate(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // background
                        onPrimary: Colors.black, // foreground
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.white)
                        ),
                      ),
                      child: Text('${formatter.format(dateEnd)}', style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        decorationColor: Colors.black,
                      ),)
                  ),
                ),
              ],
            ),

            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: (){

                      final res = addBalance(http.Client(), new AddBalanceRequest(dateStart:dateStart, dateEnd: dateEnd));
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
