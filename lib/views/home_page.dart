import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/Models/debito.dart';
import 'package:financial_app/database/firestore.dart';
import 'package:financial_app/database/firestore_calculator.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/access/login.dart';
import 'package:financial_app/views/search.dart';
import 'package:financial_app/views/update.form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isPendente = true;
  bool _isCredit = false;
  double _currentValue = 0;
  DateTime _date = DateTime.now();
  late TextEditingController _name;
  late TextEditingController _description;
  late TextEditingController _data;
  late TextEditingController _amount;
  late TextEditingController _number;
  late double amountInitial;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _name = TextEditingController();
    _description = TextEditingController();
    _data = TextEditingController();
    _amount = TextEditingController();
    _number = TextEditingController();
    amountInitial = _currentValue;
  }

  @override
  void dispose() {
    super.dispose();
    _name = TextEditingController();
    _description = TextEditingController();
    _data = TextEditingController();
    _number = TextEditingController();
    _amount = TextEditingController();
    amountInitial = _currentValue;
  }

  _selectDate(BuildContext context) async {
    DateTime? _dataPicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
            data: ThemeData(
              primaryColor: Colors.deepPurpleAccent,
              accentColor: Colors.deepPurpleAccent,
              appBarTheme:
                  AppBarTheme(backgroundColor: Colors.deepPurpleAccent),
            ),
            child: child!);
      },
    );
    if (_dataPicker != null && _dataPicker != _date) {
      setState(() {
        _date = _dataPicker;
      });
    }
  }

  void addLancamento() async {
    if (_formKey.currentState!.validate()) {
      DebitModel debit = DebitModel(
        amount: _currentValue, //double.parse(_amount.text),
        date: _date,
        name: _name.text,
        type: _isCredit == true ? "Concluído" : "Pendente",
        description: _description.text,
        number: _number.text,
      );
      await FirestoreDb.createDebit(debit);
      print(debit);

      Navigator.of(context).pop();
    }
  }

  void _newDebit() {
    var mask = MaskTextInputFormatter(mask: '(##) # ####-####');

    _currentValue = 0;
    _name.clear();
    _description.clear();
    _isCredit = false;
    _data.clear();
    _date = DateTime.now();
    _number.clear();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Novo Débito'),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Débito',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          activeColor: secondaryColor,
                          value: _isCredit,
                          onChanged: (newValue) {
                            setState(() {
                              _isCredit = newValue;
                            });
                          },
                        ),
                        Text(
                          'Crédito',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),*/
                    SizedBox(
                      height: 5,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _textInput(
                            hint: 'Nome do Cliente',
                            icon: Icons.person,
                            validar: (String? val) {
                              if (val!.isEmpty || val == null) {
                                return "Campo de nome obrigatório";
                              }
                            },
                            controller: _name,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          _textInput(
                            hint: 'Descrição do produto ou serviço',
                            icon: Icons.list_alt,
                            controller: _description,
                            maxlines: 3,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          _textInput(
                            hintStyle: _currentValue == 0
                                ? null
                                : TextStyle(color: black),
                            hint: _currentValue == 0
                                ? 'Valor'
                                : NumberFormat.currency(
                                    symbol: 'R\$',
                                    decimalDigits: 2,
                                    locale: ('pt_Br'),
                                  ).format(_currentValue),
                            icon: Icons.attach_money,
                            onSaved: null,
                            controller: _amount,
                            /*format: <TextInputFormatter>[
                                currencyFormat,
                                CurrencyTextInputFormatter(
                                  locale: 'pt-br',
                                  decimalDigits: 0,
                                  symbol: 'R\$',
                                )
                              ],*/
                            validar: (String? value) {
                              if (_currentValue == 0) {
                                return "Adicione um valor!";
                              } else if (_currentValue < 0) {
                                return "Adicione um valor positivo!";
                              }
                              /*if (value != null &&
                                  double.tryParse(value) == null) {
                                return "Somente números";
                              }*/
                            },
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    child: SimpleCalculator(
                                      value: _currentValue,
                                      hideExpression: false,
                                      hideSurroundingBorder: true,
                                      onChanged: (key, value, expression) {
                                        setState(() {
                                          _currentValue = value ?? 0;
                                        });
                                        print("$key\t$value\t$expression");
                                      },
                                      onTappedDisplay: (value, details) {
                                        print(
                                            "$value\t${details.globalPosition}");
                                      },
                                      theme: CalculatorThemeData(
                                          borderColor: white,
                                          displayColor: white,
                                          numColor: white,
                                          operatorColor: primaryColor,
                                          expressionColor: white,
                                          commandColor: white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          _textInput(
                            hint: 'Celular',
                            icon: Icons.phone_android,
                            controller: _number,
                            validar: (String? value) {
                              var format = RegExp(
                                  r'^\([1-9]{2}\) [9] [6-9]{1}[0-9]{3}\-[0-9]{4}$');
                              if (value!.isEmpty) {
                                return null;
                              } else if (!format.hasMatch(value)) {
                                return ('Formato invalido');
                              }
                            },
                            format: [mask],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          _textInput(
                            //enable: false,
                            icon: Icons.calendar_today,
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {
                                _selectDate(context);
                              });
                            },
                            hint: "${_date.day}/${_date.month}/${_date.year}",
                            controller: _data,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    focusNode: FocusNode(canRequestFocus: true),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    //Colors.grey[350],
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: addLancamento,
                    child: Text(
                      'SALVAR',
                      style: TextStyle(color: primaryColor, fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          );
        });
      },
    );
  }

  //List<DebitModel> _transactionList = [];

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: white,
      body: Column(
        children: <Widget>[
          _appBarBottomSection(),
          _mainBody(),
          // _floatingButton(),
        ],
      ),
      floatingActionButton: _floatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************

  /// App Bar
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: PopupMenuButton(
          icon: Image.asset(
            'assets/images/menu.png',
            fit: BoxFit.fitWidth,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: black,
                ),
                onTap: () async {
                  await auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false);
                },
                title: Text('Sair'),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(_isCredit));
              },
              icon: Icon(Icons.search)),
        )
      ],

      /*actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
              onTap: () => print('Profile Tapped'),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
              ),
        ),
      ],*/
    );
  }

  _appBarBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreDb.readDebits(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          double totalDebits = totalPendente(snapshot.data!.docs);
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'R\$',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                  Text(
                    NumberFormat('##0.00', 'pt_Br').format(totalDebits),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Total Pendente',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /// Income
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: RaisedButton(
                      //autofocus: false,
                      splashColor: Colors.white.withOpacity(0.8),
                      color: _isPendente ? white : primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topRight: Radius.circular(30))),
                      onPressed: () => setState(() {
                        if (_isPendente == false) {
                          _isPendente = !_isPendente;
                        }
                      }),
                      child: Text(
                        'Pendentes',
                        style: TextStyle(
                          color: _isPendente == true
                              ? secondaryColor
                              : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),

                  /// Outcome
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: RaisedButton(
                      splashColor: Colors.white.withOpacity(0.8),
                      color: _isPendente == false ? white : primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topLeft: Radius.circular(30))),
                      onPressed: () => setState(() {
                        if (_isPendente == true) {
                          _isPendente = !_isPendente;
                        }
                      }),
                      child: Text(
                        'Pagos',
                        style: TextStyle(
                          color: _isPendente == true
                              ? Colors.white
                              : secondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Main Body
  _mainBody() {
    String de = 'de';
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _isPendente ? 'Débitos' : 'Débitos Pagos',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                StreamBuilder<QuerySnapshot>(
                  stream: _isPendente
                      ? FirestoreDb.readDebits()
                      : FirestoreDb.readFinalized(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Text('erro');
                      print(snapshot.error);
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Center(child: Text('Sem dados para mostrar'));
                    } else {
                      return ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                          height: 0,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = DebitModel.fromMap(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
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
                                  return UpdateForm(
                                      doc, docId, _isCredit, amountInitial);
                                },
                              );
                            },
                            onLongPress: () async {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Deseja realmente excluir?',
                                      style: TextStyle(
                                          color: black.withOpacity(0.8),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Não',
                                          style: TextStyle(color: black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirestoreDb.deleteDebit(
                                              docId: docId);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Sim',
                                          style: TextStyle(color: primaryColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.2)),
                                  ),
                                  child: Image.asset(
                                    "assets/images/avatar.png",
                                    //fit: BoxFit.cover,
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
                                      ? DateFormat('dd MMM, yyyy', 'pt_BR')
                                          .format(doc.date!)
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _floatingButton() {
    return GestureDetector(
      onTap: _newDebit,
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 3,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _textInput(
      {TextEditingController? controller,
      hint,
      icon,
      onSaved,
      validar,
      format,
      onTap,
      hintStyle,
      initValue,
      enable,
      maxlines}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            offset: Offset(.0, 2.0),
          )
        ],
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: hintStyle,
          hoverColor: primaryColor,
          prefixIcon: Icon(
            icon,
          ),
        ),
        onSaved: onSaved,
        validator: validar,
        inputFormatters: format,
        initialValue: initValue,
        onTap: onTap,
        enableInteractiveSelection: enable = false,
        maxLines: maxlines,
      ),
    );
  }
}
