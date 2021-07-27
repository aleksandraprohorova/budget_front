import 'package:budget_front/request/ArticlesRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AddArticleWidget extends StatefulWidget {
  final Function callback;

  AddArticleWidget({this.callback}){}

  @override
  AddArticleWidgetState createState() => AddArticleWidgetState(callback: callback);
}

class AddArticleWidgetState extends State<AddArticleWidget> {

  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  final Function callback;

  AddArticleWidgetState({this.callback});

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
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
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 165,
      child: Center(child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: Colors.cyan[700],
        margin: EdgeInsets.symmetric(),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("New article", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  decorationColor: Colors.white,
                ),)
            ),
            Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                        border: Border.all(
                          color: Colors.lightBlue[50],
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: EditableText(
                          textAlign: TextAlign.start,
                          controller: _controller,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            decorationColor: Colors.white,
                          ),

                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.blue,
                          maxLines: null,
                          backgroundCursorColor: Colors.black,
                          //autofocus: true,
                          focusNode: _focusNode,
                        ),
                        //Text('${articles[index].name}', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2),)),
                      )),
                )
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: (){
                      Future<bool> res = addArticle(http.Client(), AddArticleRequest(name:_controller.text));
                      res.then((value) => callback());
                      //callback();
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
                      //Navigator.pop(context);
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
