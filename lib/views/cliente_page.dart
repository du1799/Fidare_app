import 'package:financial_app/Models/cliente.dart';
import 'package:financial_app/theme/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ClientePage extends StatefulWidget {
  @override
  _ClientePageState createState() => _ClientePageState();
}

//final clienteReference = FirebaseDatabase.instance.reference().child('cliente');

class _ClientePageState extends State<ClientePage> {
  List<Cliente> listClientes = [];

  /*StreamSubscription<Event>? _clienteAddSubscript;
  StreamSubscription<Event>? _clienteChangeSubscript;

  @override
  void initState() {
    super.initState();
    listClientes = [];
    _clienteAddSubscript = clienteReference.onChildAdded.listen(_addCliente);
    _clienteChangeSubscript =
        clienteReference.onChildChanged.listen(_updateCliente);
  }

  @override
  void dispose() {
    super.dispose();
    _clienteAddSubscript?.cancel();
    _clienteChangeSubscript?.cancel();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          _mainBody(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          'Clientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => print('Profile Tapped'),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.search,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _mainBody() {
    CircleAvatar circleAvatar(String url) {
      return (Uri.tryParse(url)!.isAbsolute)
          ? CircleAvatar(
              backgroundImage: NetworkImage(url),
              radius: null,
            )
          : CircleAvatar(
              child: Icon(Icons.person),
            );
    }

    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Container(
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
                    ),
                  ),
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: listClientes.length,
                    itemBuilder: (context, id) {
                      return ListTile(
                        //_navigateToFormCliente(context, listClientes![id]),
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 60,
                          height: 60,
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.1)),
                          ),
                          //child: circleAvatar(listClientes![id].urlAvatar),
                        ),
                        title: Text(
                          'algo',
                          //listClientes![id].name,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'algo',
                          //listClientes![id].phone,
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          'algo',
                          //listClientes![id].mail,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*void _addCliente(Event event) {
    setState(() {
      listClientes!.add(Cliente.fromSnapShot(event.snapshot));
    });
  }

  void _updateCliente(Event event) {
    var isCLiente = listClientes!
        .singleWhere((cliente) => cliente.iD == event.snapshot.key);
    setState(() {
      listClientes![listClientes!.indexOf(isCLiente)] =
          Cliente.fromSnapShot(event.snapshot);
    });
  }

  void _deleteCliente(
      BuildContext context, Cliente cliente, int position) async {
    await clienteReference.child(cliente.id!).remove().then((_) {
      setState(() {
        listClientes!.removeAt(position);
        Navigator.of(context).pop();
      });
    });
  }*/

  /*void _navigateToFormCliente(BuildContext context, Cliente cliente) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClienteForm(cliente)));
  }*/
}
