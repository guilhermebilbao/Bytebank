import 'package:flutter/cupertino.dart';

import '../database/dao/contact_dao.dart';
import '../http/webclients/transaction_webclient.dart';

class AppDependencies extends InheritedWidget {
  final ContactDao contactDao;
  final TransactionWebClient transactionWebClient;

  AppDependencies({
    @required this.contactDao,
    @required this.transactionWebClient,
    @required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>();

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    //avisar quem ta usando se teve alguma modificação e é necessário fazer a atualização.
    return contactDao != oldWidget.contactDao ||
        transactionWebClient != oldWidget.transactionWebClient;
  }
}
