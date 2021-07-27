import 'package:intl/intl.dart';

import 'article.dart';

class Operation {
  int id;
  double debit;
  double credit;
  DateTime createDate;
  Article article;

  final DateFormat formatterServer = DateFormat('yyyy-MM-ddTHH:mm:ss');

  Operation({this.id, this.debit, this.credit, this.createDate, this.article});

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json['id'],
      debit: json['debit'],
      credit: json['credit'],
      createDate: DateTime.parse(json['create_date']),
      article: Article.fromJson(json['article']),
    );
  }
  Map toJson() => {
    'id': id,
    'debit': debit,
    'credit': credit,
    'create_date': formatterServer.format(createDate),
    'article': article
  };
}
