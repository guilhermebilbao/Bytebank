import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(BytebankApp(
    contactDao: ContactDao(),
  )); // con essa mudanca, o sistema tem que se adequar e tambem mandar a instancia real
}

class BytebankApp extends StatelessWidget {
  final ContactDao
      contactDao; // receber um ContactDao, isso deve permitir uma flexibilidade na chamada da classe, para permitir o mock enviar a instancia

  BytebankApp(
      {@required
          this.contactDao}); // possibilita enviar o mock via contrutor, declarando como um parametro nominal e opcional, mas queremos que seja enviado

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      contactDao: contactDao,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: Dashboard(),
      ),
    );
  }
}
