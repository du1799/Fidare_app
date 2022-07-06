import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/Models/debito.dart';

double totalExpense(List<DocumentSnapshot> snapshots) => snapshots
    .where((el) => el['type'] == DebitModel(type: 'Debito'))
    .fold(0.0, (prev, next) => prev + next['amount']);

double totalPendente(List<DocumentSnapshot> snapshots) =>
    snapshots.fold(0.0, (prev, next) => prev + next['amount']);

/*double totalPendente(List<DocumentSnapshot> snapshots){
  return snapshots.where((element) => element['amount']==De)

}*/
