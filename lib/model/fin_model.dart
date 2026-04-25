// To parse this JSON data, do
//
//     final financeModel = financeModelFromJson(jsonString);

import 'dart:convert';

FinanceModel financeModelFromJson(String str) =>
    FinanceModel.fromJson(json.decode(str));

String financeModelToJson(FinanceModel data) => json.encode(data.toJson());

class FinanceModel {
  String? id;
  String? customerName;
  String? phoneNumber;
  String? dateIssued;
  double? amountTaken;
  double? amountPaid;
  String? description;
  double? interestRate;
  double? fineAmount;

  FinanceModel({
    this.id,
    this.customerName,
    this.phoneNumber,
    this.dateIssued,
    this.amountTaken,
    this.amountPaid,
    this.description,
    this.interestRate,
    this.fineAmount,
  });

  double get intrestAmount => (interestRate ?? 0) * (amountTaken ?? 0) / 100;

  double get totalAmount =>
      (amountTaken ?? 0) + (intrestAmount) + (fineAmount ?? 0);

  double get balance => (totalAmount) - (amountPaid ?? 0);

  String get status => balance == 0 ? "CLOSED" : "OPEN";

  factory FinanceModel.fromJson(Map<String, dynamic> json) => FinanceModel(
    id: json["id"],
    customerName: json["customerName"],
    phoneNumber: json["phoneNumber"],
    dateIssued: json["dateIssued"],
    amountTaken: json["amountTaken"],
    amountPaid: json["amountPaid"],
    description: json["description"],
    interestRate: json["interestRate"],
    fineAmount: json['fineAmount'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerName": customerName,
    "phoneNumber": phoneNumber,
    "dateIssued": dateIssued,
    "amountTaken": amountTaken,
    "amountPaid": amountPaid,
    "description": description,
    "interestRate": interestRate,
    'fineAmount': fineAmount,
  };
}
