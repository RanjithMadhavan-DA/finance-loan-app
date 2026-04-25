// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  String? id;
  String? loanId;
  String? type;
  double? amount;
  String? date;

  TransactionModel({this.id, this.loanId, this.type, this.amount, this.date});

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        loanId: json["loanId"],
        type: json["type"],
        amount: json["amount"].toDouble(),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "loanId": loanId,
    "type": type,
    "amount": amount,
    "date": date,
  };
}
