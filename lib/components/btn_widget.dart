import 'package:financial_app/theme/colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  var btnText = "";
  var onClick;

  ButtonWidget({required this.btnText, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            secondaryColor,
            Colors.deepOrangeAccent.shade200,
          ]),
          color: secondaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey..withOpacity(0.5),
              blurRadius: 2,
              offset: Offset(.0, 2.0),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
