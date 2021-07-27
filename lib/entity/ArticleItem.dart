import 'dart:ui';

class ArticleItem {
  final String name;
  final double sum;

  Color color;

  ArticleItem({this.name, this.sum});

  factory ArticleItem.fromJson(Map<String, dynamic> json) {
    return ArticleItem(
      name: json['name'],
      sum: json['sum'],
    );
  }
}
