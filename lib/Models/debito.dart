import 'package:cloud_firestore/cloud_firestore.dart';

class DebitModel {
  String? id;
  String? logo;
  DateTime? date;
  double? amount;
  String? name;
  String? type;
  String? description;
  String? number;

  DebitModel(
      {this.id = '',
      this.logo,
      this.amount,
      this.date,
      this.name,
      this.type,
      this.description,
      this.number});

  DebitModel.map(dynamic obj) {
    this.logo = obj['logo'];
    this.date = obj['date'];
    this.amount = obj['amount'];
    this.name = obj['name'];
    this.type = obj['type'];
    this.description = obj['description'];
    this.number = obj['number'];
  }
  /*String get id => id!;
  String get logo => logo!;
  String get date => date!;
  String get amount => amount!;
  String get name => name!;
  String get type => type!;
  String get description => description!;*/

  Map<String, dynamic>? toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['logo'] = logo;
    map['date'] = date;
    map['amount'] = amount;
    map['name'] = name;
    map['type'] = type;
    map['description'] = description;
    map['number'] = number;
    return map;
  }

  factory DebitModel.fromMap(Map<String, dynamic>? map) {
    return DebitModel(
      id: map?['id'],
      logo: map?['logo'],
      date: map?['date'].toDate(),
      amount: map?['amount'],
      name: map?['name'],
      type: map?['type'],
      description: map?['description'],
      number: map?['number'],
    );
  }
}
