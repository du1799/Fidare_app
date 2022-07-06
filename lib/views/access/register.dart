import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_app/components/btn_widget.dart';
import 'package:financial_app/database/firestore.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/access/login.dart';
import 'package:financial_app/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingUp extends StatefulWidget {
  String? id;
  String? email;
  String? password;
  String? nameUser;
  SingUp({this.id, this.email, this.nameUser, this.password});

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _validation() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        await auth.createUserWithEmailAndPassword(
            email: widget.email!, password: widget.password!);

        FirebaseFirestore.instance
            .collection('User')
            .doc(auth.currentUser!.uid)
            .set(
          {
            "UserName": widget.nameUser,
          },
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        print(auth);
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text('Esse email já está sendo usado!'),
          ),
        );
      }
    } else {}
  }

  bool obsText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.deepPurpleAccent,
              Colors.deepPurpleAccent.shade100,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Criar Conta',
                    style: TextStyle(
                        color: white,
                        fontSize: 55,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Preencha os campos para continuar.',
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      _textInput(
                          hint: 'Nome Completo',
                          icon: Icons.person,
                          validar: (String? value) {
                            if (value!.isEmpty) {
                              return 'Por favor, insira seu nome!';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.nameUser = value;
                              print(widget.nameUser);
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      _textInput(
                          hint: 'Email',
                          icon: Icons.email,
                          validar: (String? value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.email = value;
                              print(widget.email);
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      _textInput(
                          obscureTextfield: obsText,
                          hint: 'Senha',
                          icon: Icons.password_rounded,
                          validar: (String? value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            } else if (value.length < 6) {
                              return 'No mínimo 6 letras!';
                            }
                          },
                          onChanged: (value) {
                            widget.password = value;
                            print(widget.password);
                          }),
                      SizedBox(height: 40),
                      ButtonWidget(
                        btnText: 'Registrar',
                        onClick: _validation,
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Já tem uma conta?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (ctx) => LoginPage(),
                              ));
                            },
                            child: Text(
                              'Login!',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _textInput(
      {controller,
      hint,
      icon,
      onChanged,
      validar,
      format,
      suffixIcon,
      obscureTextfield}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(.0, 9.0),
          )
        ],
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Center(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(icon),
            enabledBorder: InputBorder.none,
            suffixIcon: suffixIcon,
            errorStyle: TextStyle(
              color: red,
            ),
          ),
          obscureText: obscureTextfield == false,
          onChanged: onChanged,
          validator: validar,
          inputFormatters: format,
        ),
      ),
    );
  }
}
