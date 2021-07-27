import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/AddArticleWidget.dart';
import '../request/ArticlesRequests.dart';
import '../widget/ArticlesListWidget.dart';
import '../entity/article.dart';

import 'package:http/http.dart' as http;

class ArticlesPage extends StatefulWidget {

  @override
  ArticlesPageState createState() {
    return ArticlesPageState();
  }
}

class ArticlesStreamBuilder extends StatefulWidget {
  ArticlesStreamBuilderState state = new ArticlesStreamBuilderState();
  ArticlesStreamBuilder({Key key}): super(key: key);
  @override
  ArticlesStreamBuilderState createState() {
    return state;
  }
  void refreshArticles() {
    state.refreshArticles();
  }

}
class ArticlesStreamBuilderState extends State<ArticlesStreamBuilder> {
  final articlesStream = StreamController<List<Article>>();

  void refreshArticles() {
    log('refresh articles');
    Future<List<Article>> res = fetchArticles(http.Client());
    res.then((value) {
      if (value.isNotEmpty) {
        setState(() {
          articlesStream.sink.add(value);
          articlesStream.add(value);
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    articlesStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: articlesStream.stream,
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
          return ArticlesListWidget(key: UniqueKey(), articles: snapshot.data);
        }
    );
  }

}


class ArticlesPageState extends State<ArticlesPage> {
  List<Widget> widgets = [];
  bool isPressed;
  List<Article> articles;
  ArticlesStreamBuilder articlesStreamBuilder = new ArticlesStreamBuilder(key: UniqueKey());

  ArticlesPageState();

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
          label: const Text('Add article'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.cyan[700],
        )
    );
  }
  @override
  void initState() {
    super.initState();
    widgets.add(articlesStreamBuilder);
    articlesStreamBuilder.refreshArticles();
    isPressed = false;
  }

  void addButtonPressed() {
    setState(() {
      log('pressed add button');
      isPressed = true;
      widgets.add(Center(child: AddArticleWidget(callback: () {
        setState(() {
          widgets.removeLast();
          articlesStreamBuilder.refreshArticles();
          isPressed = false;
        });
      })
      )
      );
    });
  }

}
