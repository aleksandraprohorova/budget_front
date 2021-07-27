import 'dart:developer';

import 'package:budget_front/request/ArticlesRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/article.dart';

import 'package:http/http.dart' as http;

class ArticleItem extends StatefulWidget {
  Article article;

  ArticleItem({this.article}){}

  @override
  _ArticleItemState createState() => _ArticleItemState(article: article);
}

class _ArticleItemState extends State<ArticleItem> {
  Article article;

  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  _ArticleItemState({this.article});

  @override
  void initState() {
    super.initState();
    _controller.value = _controller.value.copyWith(
        text: article.name);
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      /*Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
      res.then((value) {
        if (value) {
          article.name = _controller.text.toString();
        }
      });*/
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    _focusNode.addListener(() {
      if(!_focusNode.hasFocus)
      {
        Future<bool> res = updateArticle(http.Client(), UpdateArticleRequest(article: Article(name:_controller.text, id: article.id)));
        res.then((value) {
          if (value) {
            article.name = _controller.text.toString();
          }
          else {
            _controller.value = _controller.value.copyWith(
              text: article.name,
              selection:
              TextSelection(baseOffset: article.name.length, extentOffset: article.name.length),
              composing: TextRange.empty,
            );
          }
        });
      }
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
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: Colors.lightBlue[50],
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Center(child:SizedBox(
            width: 300,
            height: 60,
            child: Center(
              child: EditableText(
                textAlign: TextAlign.start,
                //focusNode: _focusNode,
                controller: _controller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
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
          ),
        )
    );
  }
}

class ArticlesListWidget extends StatefulWidget {
  List<Article> articles;
  ArticlesListWidget({Key key, this.articles}): super(key: key);

  @override
  ArticlesListWidgetState createState() {
    return ArticlesListWidgetState(articles: articles);
  }
}

class ArticlesListWidgetState extends State<ArticlesListWidget>
{
  List<Article> articles;
  ArticlesListWidgetState({this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          final item = articles[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                articles.removeAt(index);
                Future<bool> res = deleteArticle(http.Client(), item.id);
                res.then((value) {
                  if (value) {

                  }
                });

              });
            },
            child: ArticleItem(article: articles[index],));
          //return ArticleItem(article: articles[index],);
        }

    );
  }
}

