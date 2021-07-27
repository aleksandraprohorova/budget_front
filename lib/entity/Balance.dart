import 'package:intl/intl.dart';

class Balance {
  int id;
  double debit;
  double credit;
  double amount;
  DateTime createDate;

  final DateFormat formatterServer = DateFormat('yyyy-MM-ddTHH:mm:ss');

  Balance({this.id, this.debit, this.credit, this.amount, this.createDate});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      id: json['id'],
      debit: json['debit'],
      credit: json['credit'],
      amount: json['amount'],
      createDate: DateTime.parse(json['create_date']),
    );
  }
  Map toJson() => {
    'id': id,
    'debit': debit,
    'credit': credit,
    'amount': amount,
    'create_date': formatterServer.format(createDate)
  };
}
