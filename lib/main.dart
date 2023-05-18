import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/screens/counter.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/name.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/bytebankTheme.dart';
import 'http/webclients/transaction_webclient.dart';

void main() {
  runApp(BytebankApp(
    contactDao: ContactDao(),
    transactionWebClient: TransactionWebClient(),
  )); // con essa mudanca, o sistema tem que se adequar e tambem mandar a instancia real
}

class LogObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print("${bloc.runtimeType} > $change");
    super.onChange(bloc, change);
  }
}

class BytebankApp extends StatelessWidget {
  final ContactDao
      contactDao; // receber um ContactDao, isso deve permitir uma flexibilidade na chamada da classe, para permitir o mock enviar a instancia
  final TransactionWebClient transactionWebClient;

  BytebankApp({
    @required this.contactDao,
    @required this.transactionWebClient,
  }); // possibilita enviar o mock via contrutor, declarando como um parametro nominal e opcional, mas queremos que seja enviado

  @override
  Widget build(BuildContext context) {
    Bloc.observer = LogObserver();
    return AppDependencies(
      transactionWebClient: transactionWebClient,
      // agora qualquer tipo de widget dentro dessa arvore de widgets pode acessar o transactionWebClient e o contactDao a partir do nosso AppDependices
      contactDao: contactDao,

      child: MaterialApp(
        theme: bytebankTheme,
        //home: NameContainer(),
        //home: CounterContainer(),
        home: DashboardContainer(),
      ),
    );
  }
}
