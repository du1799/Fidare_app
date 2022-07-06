import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/Models/debito.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class FirestoreService with ChangeNotifier {
  List<DebitModel> _listDebits = [];

  late FirebaseFirestore db;

  /* _read() async {
    if (_listDebits.isEmpty) {
      final snapshot =
          await db.collection('Lancamento').get();

      snapshot.docs.forEach((doc) {
        DebitModel moeda = MoedaRepository.tabela
            .firstWhere((moeda) => moeda.sigla == doc.get('sigla'));
        _listDebits.add(moeda);
        notifyListeners();
      });
    }
  }*/

  saveAll(List<DebitModel> transactions) {
    transactions.forEach((transaction) async {
      if (!_listDebits.any((atual) => atual.name == transaction.name)) {
        _listDebits.add(transaction);
        await db.collection('Lancamento').doc(transaction.name).set({
          'name': transaction.name,
          'description': transaction.description,
          'amount': transaction.amount,
          'date': transaction.date,
        });
      }
    });
    notifyListeners();
  }
}
