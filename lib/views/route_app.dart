/*//import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:financial_app/views/cliente_page.dart';
import 'package:financial_app/views/debitos_page.dart';
import 'package:financial_app/views/home_page.dart';
import 'package:financial_app/views/user_config_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int floatIndex = 0;
  int pageIndex = 0;

  List<Widget> pages = [
    HomePage(),
    ClientePage(),
    DebitoPage(),
    UserConfigPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        foregroundColor: Colors.white,
        activeForegroundColor: Colors.white,
        backgroundColor: primaryColor,
        overlayOpacity: 0,
        elevation: 0,
        buttonSize: 65,
        animationSpeed: 200,
        animatedIconTheme: IconThemeData(size: 24.0),
        activeBackgroundColor: secondaryColor,
        curve: Curves.bounceInOut,
        children: [
          SpeedDialChild(
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              child: Icon(
                Icons.attach_money,
                color: Colors.white,
              ),
              backgroundColor: primaryColor,
              label: 'Add Débito',
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/formDebito');
                });
              }),
          SpeedDialChild(
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              child: Icon(
                Icons.person_add_alt_rounded,
                color: Colors.white,
              ),
              backgroundColor: primaryColor,
              label: 'Add Cliente',
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/formCliente');
                });
              })
        ],
      ),
      /*floatingActionButton: /*FloatingActionButton(*/
          AnimatedFloatingActionButton(
        colorStartAnimation: Colors.deepOrangeAccent,
        animatedIconData: AnimatedIcons.menu_close,
        fabButtons: <Widget>[
          examploUm(),
          examploDois(),
        ],*/
      //aqui//
      /* onPressed: () {
            selectedTab(0);
          },
          child: Icon(
            Icons.add,
            size: 25,
          ),
          backgroundColor: Colors.deepOrangeAccent*/
      //params
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /*Widget examploUm() {
    return Container(
      child: FloatingActionButton(
        tooltip: "Add Cliente",
        onPressed: () {
          setState(() {
            Navigator.of(context).pushNamed('/formCliente');
            //selectedTab(5);
            //floatIndex = floatIndex + 1;
          });
        },
        focusColor: Colors.deepPurpleAccent,
        focusElevation: 16.0,
        heroTag: 'see',
        elevation: 2.0,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget examploDois() {
    return Container(
      child: FloatingActionButton(
        tooltip: "Add Débito",
        onPressed: () {
          setState(() {
            Navigator.of(context).pushNamed('/formDebito');
            //floatIndex++;
          });
        },
        focusColor: Colors.deepPurpleAccent,
        focusElevation: 16.0,
        heroTag: 'Anything',
        elevation: 2.0,
        child: Icon(
          Icons.attach_money_rounded,
          color: Colors.white,
        ),
      ),
    );
  }*/

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    /*List<IconData> iconItems = [
      Ionicons.md_home,
      Ionicons.md_person_add,
      Ionicons.md_list,
      Ionicons.md_person,
    ];*/

    /*return AnimatedBottomNavigationBar(
      activeColor: Colors.deepOrangeAccent,
      splashColor: Colors.deepOrangeAccent,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );*/
    return BottomNavigationBar(
      onTap: (index) {
        selectedTab(index);
      },
      currentIndex: pageIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.deepOrangeAccent,
      selectedFontSize: 14,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            //color: Colors.grey,
          ),
          title: Text(
            'Início',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_add,
            //color: Colors.grey,
          ),
          title: Text(
            'Clientes',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            //color: Colors.grey,
          ),
          title: Text(
            'Débitos',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          label: null,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            //color: Colors.grey,
          ),
          title: Text(
            'Usuário',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
*/