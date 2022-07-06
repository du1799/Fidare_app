import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/Models/debito.dart' as deb;
import 'package:financial_app/views/access/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDb {
  //static String? userId;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static SingUp userId = SingUp();
  static FirebaseFirestore docs = FirebaseFirestore.instance;

  /*static Stream<QuerySnapshot>? sumAmounts() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento')
        .where('amount')
        .snapshots();
  }*/

  static Stream<QuerySnapshot>? sumDebits() {
    CollectionReference collectionReference = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento');
    return collectionReference.where('amount', isEqualTo: 0).snapshots();
  }

  static Future<void> createDebit(deb.DebitModel debit) async {
    DocumentReference documentReference = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento')
        .doc();
    documentReference
        .set(debit.toMap())
        .whenComplete(() => print('Novo Lançamento inserido no firestore'))
        .catchError((e) => print(e));
  }

  static addData(deb.DebitModel debit) async {
    docs.collection('Lancamento').add(debit.toMap()!);
  }

  static Future<void> updateDebit(deb.DebitModel debit, String docId) async {
    DocumentReference documentReference = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento')
        .doc(docId);
    documentReference
        .set(debit.toMap())
        .whenComplete(() => print('Formulario atualizado'))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readDebits() {
    CollectionReference debitsCollection = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento');
    return debitsCollection
        .where('type', isEqualTo: 'Pendente')
        .orderBy('date', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> readFinalized() {
    CollectionReference debitsCollection = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento');
    return debitsCollection
        .where('type', isEqualTo: 'Concluído')
        .orderBy('date', descending: true)
        .snapshots();
  }

  static Future<QuerySnapshot> search(String queryString) {
    CollectionReference debitsCollection = docs
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento');
    return debitsCollection
        .where('name', isGreaterThanOrEqualTo: queryString.trim())
        .get();
  }

  static Future<void> deleteDebit({required String docId}) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Lancamento')
        .doc(docId);
    documentReference
        .delete()
        .whenComplete(() => print('Debito deletado do firebase'))
        .catchError((e) => print(e));
  }
}
