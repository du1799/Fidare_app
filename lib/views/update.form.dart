import 'package:financial_app/Models/debito.dart';
import 'package:financial_app/database/firestore.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpdateForm extends StatefulWidget {
  final docId;
  final DebitModel debit;
  bool? isCredit;
  final double? amountInitial;

  UpdateForm(this.debit, this.docId, this.isCredit, this.amountInitial);
  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name =
      TextEditingController(text: widget.debit.name);
  late TextEditingController _description =
      TextEditingController(text: widget.debit.description);
  late TextEditingController _data = TextEditingController();
  late TextEditingController _amount =
      TextEditingController(/*text: widget.debit.amount.toString()*/);
  late TextEditingController _number =
      TextEditingController(text: widget.debit.number);
  /*@override
  void initState() {
    amountInit = widget.debit.amount;
    super.initState();
  }*/

  _selectDate(BuildContext context) async {
    DateTime? _dataPicker = await showDatePicker(
      context: context,
      initialDate: widget.debit.date!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
            data: ThemeData(
              primaryColor: primaryColor,
              accentColor: primaryColor,
            ),
            child: child!);
      },
    );
    if (_dataPicker != null && _dataPicker != widget.debit.date) {
      setState(() {
        widget.debit.date = _dataPicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mask = MaskTextInputFormatter(mask: '(##) # ####-####');
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Atualizar Débito'),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'DEVENDO',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isCredit == false ? secondaryColor : black,
                    ),
                  ),
                  Switch(
                    hoverColor: secondaryColor.withOpacity(0.2),
                    activeColor: secondaryColor,
                    value: widget.isCredit!,
                    onChanged: (newValue) {
                      setState(() {
                        widget.isCredit = newValue;
                        print(widget.isCredit);
                      });
                    },
                  ),
                  Text(
                    'CONCLUÍDO',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isCredit == true ? secondaryColor : black,
                    ),
                  ),
                ],
              ),
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
                      color: white,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    _textInput(
                      hint: 'Descrição do produto ou serviço',
                      icon: Icons.list_alt,
                      controller: _description,
                      maxlines: 3,
                      color: white,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    _textInput(
                      hint: widget.isCredit == true
                          ? NumberFormat.currency(
                              symbol: 'R\$',
                              decimalDigits: 2,
                              locale: ('pt_Br'),
                            ).format(widget.amountInitial)
                          : NumberFormat.currency(
                                  symbol: 'R\$',
                                  decimalDigits: 2,
                                  locale: ('pt_Br'))
                              .format(widget.debit.amount),
                      hintStyle: TextStyle(color: black),
                      color: widget.isCredit == true
                          ? Colors.deepPurpleAccent.shade100.withOpacity(0.6)
                          : white,
                      icon: Icons.attach_money,
                      controller: _amount,
                      enable: widget.isCredit == true ? false : true,
                      /*format: <TextInputFormatter>[
                                currencyFormat,
                                CurrencyTextInputFormatter(
                                  locale: 'pt-br',
                                  decimalDigits: 0,
                                  symbol: 'R\$',
                                )
                              ],*/
                      validar: (String? value) {
                        if (widget.debit.amount == 0) {
                          if (widget.isCredit == true) {
                            return null;
                          } else {
                            return "Adicione um valor";
                          }
                        } else if (widget.debit.amount! < 0) {
                          if (widget.isCredit == true) {
                            return null;
                          } else {
                            return "Adicione um valor positivo!";
                          }
                        }
                      },
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: SimpleCalculator(
                                value: widget.debit.amount!,
                                hideExpression: false,
                                hideSurroundingBorder: true,
                                onChanged: (key, value, expression) {
                                  setState(() {
                                    widget.debit.amount = value ?? 0;
                                  });
                                  print("$key\t$value\t$expression");
                                },
                                onTappedDisplay: (value, details) {
                                  print("$value\t${details.globalPosition}");
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
                    SizedBox(
                      height: 2,
                    ),
                    _textInput(
                      hint: 'Celular',
                      icon: Icons.phone_android,
                      color: white,
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
                        FocusScope.of(context).requestFocus(new FocusNode());
                        setState(() {
                          _selectDate(context);
                        });
                      },
                      hint:
                          "${widget.debit.date!.day}/${widget.debit.date!.month}/${widget.debit.date!.year}",
                      controller: _data,
                      hintStyle: TextStyle(color: Colors.black),
                      color: white,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  DebitModel debit = DebitModel(
                    name: _name.text,
                    description: _description.text,
                    amount: widget.isCredit == true
                        ? widget.amountInitial
                        : widget.debit.amount,
                    date: widget.debit.date,
                    type: widget.isCredit == true ? 'Concluído' : 'Pendente',
                    number: _number.text,
                  );

                  await FirestoreDb.updateDebit(debit, widget.docId);
                  print(debit);

                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'ATUALIZAR',
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _textInput({
    TextEditingController? controller,
    hint,
    icon,
    onSaved,
    validar,
    format,
    onTap,
    hintStyle,
    initValue,
    enable,
    color,
    maxlines,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: color,
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
        maxLines: maxlines,
        enabled: enable,

        //enableInteractiveSelection: true,
      ),
    );
  }
}
