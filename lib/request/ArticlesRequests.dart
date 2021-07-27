import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:budget_front/request/AuthRequests.dart';
import 'package:budget_front/entity/article.dart';
import 'package:http/http.dart' as http;

import '../entity/ArticleItem.dart';

List<Article> parseArticles(List<dynamic> responseBody) {
  //log('parseArticles responseBody $responseBody');
  //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return responseBody.map<Article>((json) => Article.fromJson(json)).toList();
}

class ArticlesListResponse {
  List<Article> articles;
  ArticlesListResponse({this.articles});

  factory ArticlesListResponse.fromJson(Map<String, dynamic> json) {
    log('articleslistResponse json $json');
    List<dynamic> jsonDynamic = json['articles'];

    //final parsed = jsonDecode(jsonDynamic).cast<Map<String, dynamic>>();

    //log('articleslistjson $articlesJson');
    List<Article> articlesList = parseArticles(jsonDynamic);
    return ArticlesListResponse(
      articles: articlesList,
    );
  }
}

Future<List<Article>> fetchArticles(http.Client client) async {
  log('fetch articles');
  log(TokenManager.getToken());
  final response = await client.get(Uri.http('localhost:8082', 'articles'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${TokenManager.getToken()}'
      }
      //headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: "Bearer ${TokenManager.getToken()}"}
  );
  log('${response.statusCode.toString()}, ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    ArticlesListResponse articlesListResponse = ArticlesListResponse.fromJson(jsonBody);
    List<Article> articlesList = articlesListResponse.articles;
    return articlesList;
    //return ArticlesListResponse.fromJson(jsonBody.cast<Map<String, dynamic>>()).articles;
  } else {
    throw Exception('Failed to load articles');
  }
}

class UpdateArticleRequest
{
  Article article;
  UpdateArticleRequest({this.article}){}
  Map toJson() => {
    'article': article
  };
}
class AddArticleRequest {
  String name;
  AddArticleRequest({this.name}){}
  Map toJson() => {
    'name': name
  };
}


Future<bool> updateArticle(http.Client client, UpdateArticleRequest request) async {
  log('update ${request.article.name}');
  var data = jsonEncode(request);
  final response = await client.put(Uri.http('localhost:8082', 'articles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
      },
    body: data);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}

Future<bool> deleteArticle(http.Client client, int id) async {
  log('delete article');
  log(id.toString());
  Uri url = Uri.http('localhost:8082','articles',{ "id": id.toString() });
  final response = await client.delete(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
    },);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}

Future<bool> addArticle(http.Client client, AddArticleRequest request) async {
  log('add Articles');
  log(request.name);
  var data = jsonEncode(request);
  final response = await client.post(Uri.http('localhost:8082', 'articles'),
      /*headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${TokenManager.getToken()}'
      }*/
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
      },
      body: data);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}

List<ArticleItem> parseArticleItems(List<dynamic> responseBody) {
  //log('parseArticles responseBody $responseBody');
  //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return responseBody.map<ArticleItem>((json) => ArticleItem.fromJson(json)).toList();
}

class ArticleItemsListResponse {
  List<ArticleItem> articleItems;
  ArticleItemsListResponse({this.articleItems});

  factory ArticleItemsListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonDynamic = json['items'];

    List<ArticleItem> articlesList = parseArticleItems(jsonDynamic);
    return ArticleItemsListResponse(
      articleItems: articlesList,
    );
  }
}

Future<List<ArticleItem>> fetchArticleFlow() async {
  log('fetch flow');
  final response = await http.Client().get(Uri.http('localhost:8082', 'articles/flow'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'}
  );
  log('${response.statusCode.toString()}, ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    ArticleItemsListResponse articleItemsListResponse = ArticleItemsListResponse.fromJson(jsonBody);
    List<ArticleItem> items = articleItemsListResponse.articleItems;
    return items;
    //return ArticlesListResponse.fromJson(jsonBody.cast<Map<String, dynamic>>()).articles;
  } else {
    throw Exception('Failed to load articles');
  }
}


