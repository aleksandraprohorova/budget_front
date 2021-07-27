import 'package:budget_front/request/AuthRequests.dart';
import 'package:budget_front/page/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthorizationPage extends StatefulWidget {

  @override
  AuthorizationPageState createState() {
    return AuthorizationPageState();
  }
}

class AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController _controllerLogin = TextEditingController();
  FocusNode _focusNodeLogin = FocusNode();

  final TextEditingController _controllerPassword = TextEditingController();
  FocusNode _focusNodePassword = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controllerLogin.addListener(() {
      final String text = _controllerLogin.text.toLowerCase();
      _controllerLogin.value = _controllerLogin.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _controllerPassword.addListener(() {
      final String text = _controllerPassword.text.toLowerCase();
      _controllerPassword.value = _controllerPassword.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerLogin.dispose();
    _focusNodeLogin.dispose();
    _controllerPassword.dispose();
    _focusNodePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Budget")),
        backgroundColor: Colors.cyan[700],
        shadowColor: Colors.cyan[700],
        elevation: 0,
        toolbarHeight: 40,
      ),
      backgroundColor: Colors.cyan[700],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(8),),
          Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Center(child:TextField(
                textAlign: TextAlign.start,
                controller: _controllerLogin,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  decorationColor: Colors.white,
                ),
                decoration: new InputDecoration.collapsed(hintText: "login", hintStyle:
                    TextStyle(
                      color: Colors.grey,
                      fontSize: 19.0
                    ),
                ),

                keyboardType: TextInputType.multiline,
                cursorColor: Colors.blue,
                maxLines: 1,

                //autofocus: true,
                focusNode: _focusNodeLogin,
              ),
            ))
          ),
          Padding(padding: EdgeInsets.all(8),),
          Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.start,
                  controller: _controllerPassword,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    decorationColor: Colors.white,
                  ),

                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.blue,
                  maxLines: 1,
                  decoration: new InputDecoration.collapsed(hintText: "password", hintStyle:
                  TextStyle(
                      color: Colors.grey,
                      fontSize: 19.0
                  )
                  ),

                  //autofocus: true,
                  focusNode: _focusNodePassword,
                ),
              ))
          ),
          Center(child:ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(8),
                  child:Container(
                height: 40,
                  width: 294,
                  child:ElevatedButton(
                  onPressed: () {
                    TokenManager.updateToken(_controllerLogin.text, _controllerPassword.text,
                      () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(key: UniqueKey(), title: "Budget",)),);
                    },
                        (){
                          final snackBar = SnackBar(
                            content: Text('Wrong login or password. Try again.'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          _controllerLogin.clear();
                          _controllerPassword.clear();
                        });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      )
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                  ),
                  child: Text('login', style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    decorationColor: Colors.black,
                  ),)
              ))),
            ],
          ))
        ],
      ),
    );
  }
}
