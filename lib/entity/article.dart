import 'package:flutter/foundation.dart';

class Article {
  String name ;
  int id;
  Article({this.name, this.id});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      name: json['name'],
      id: json['id'],
    );
  }
  Map toJson() => {
    'id': id,
    'name': name,
  };
}
