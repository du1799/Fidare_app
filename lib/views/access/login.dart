import 'package:financial_app/components/btn_widget.dart';
import 'package:financial_app/main.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/access/register.dart';
import 'package:financial_app/views/home_page.dart';
import 'package:financial_app/views/route_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _validation() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        await auth.signInWithEmailAndPassword(
            email: email!, password: password!);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        print(auth);
      } on FirebaseAuthException catch (ex) {
        print(ex.message);
        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(
                'Não há registro de usuário correspondente a este identificador.'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Bem Vindo!',
                    style: TextStyle(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/fidare.png",
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                  /*Text(
                    'Login',
                    style: TextStyle(
                      color: white,
                      fontSize: 65,
                    ),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
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
                            email = value;
                            print(email);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _textInput(
                        obscureTextfield: obsText,
                        hint: 'Senha',
                        icon: Icons.password_rounded,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obsText = !obsText;
                            });
                          },
                          child: Icon(obsText == true
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        validar: (String? value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                            print(password);
                          });
                        },
                      ),
                      SizedBox(height: 40),
                      ButtonWidget(
                        btnText: 'Entrar',
                        onClick: _validation,
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Não tem uma conta?',
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
                                builder: (ctx) => SingUp(),
                              ));
                            },
                            child: Text(
                              'Registre-se aqui!',
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
          obscureText: obscureTextfield == true,
          onChanged: onChanged,
          validator: validar,
          inputFormatters: format,
        ),
      ),
    );
  }
}
