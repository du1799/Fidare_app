import 'package:firebase_database/firebase_database.dart';

class Cliente {
  String? id;
  String? nome;
  String? email;
  String? telefone;
  String? avatar;

  Cliente(this.id, this.nome, this.email, this.telefone, this.avatar);

  Cliente.map(dynamic obj) {
    this.nome = obj['nome'];
    this.email = obj['email'];
    this.telefone = obj['telefone'];
    this.avatar = obj['avatar'];
  }

  String get iD => id!;
  String get name => nome!;
  String get mail => email!;
  String get phone => telefone!;
  String get urlAvatar => avatar!;

  Cliente.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    nome = snapshot.value['nome'];
    email = snapshot.value['email'];
    telefone = snapshot.value['telefone'];
    avatar = snapshot.value['avatar'];
  }
}
