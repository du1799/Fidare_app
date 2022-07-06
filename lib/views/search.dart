import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/Models/debito.dart';
import 'package:financial_app/database/firestore.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/update.form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Search extends SearchDelegate<void> {
  bool? _isCredit;

  Search(this._isCredit);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirestoreDb.search(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Text('erro');
          print(snapshot.error);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.length == 0) {
          return Center(
              child: Text(
            'Sem dados para mostrar',
            style: TextStyle(color: black.withOpacity(0.8)),
          ));
        } else {
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = DebitModel.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);

              String docId = snapshot.data!.docs[index].id;
              final double amountInitial = doc.amount!;
              DateTime dateInit = doc.date!;

              return InkWell(
                onTap: () {
                  if (doc.date != dateInit) {
                    doc.date = dateInit;
                  }
                  if (doc.amount != amountInitial) {
                    doc.amount = amountInitial;
                  }
                  print(amountInitial);
                  _isCredit = doc.type == 'Pendente' ? false : true;
                  print(_isCredit);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return UpdateForm(doc, docId, _isCredit, amountInitial);
                    },
                  );
                },
                onLongPress: () async {
                  await FirestoreDb.deleteDebit(docId: docId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: primaryColor.withOpacity(0.2)),
                      ),
                      child: Image.asset(
                        "assets/images/avatar.png",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    title: Text(
                      doc.name!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      doc.date != null
                          ? DateFormat('dd/MM/yyyy').format(doc.date!)
                          : 'Sem data',
                      style: TextStyle(
                        color: primaryColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      (doc.type == 'Pendente' ? '-' : '+') +
                          NumberFormat.currency(
                                  decimalDigits: 2,
                                  symbol: 'R\$',
                                  locale: ('pt_Br'))
                              .format(doc.amount),
                      style: TextStyle(
                        color: doc.type == 'Pendente'
                            ? Colors.red
                            : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
