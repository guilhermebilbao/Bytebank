import 'package:flutter/cupertino.dart';

import '../database/dao/contact_dao.dart';

class AppDependencies extends InheritedWidget {
  final ContactDao contactDao;

  AppDependencies({
    @required this.contactDao,
    @required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>();

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    //pode notificar quem ta usado se teve alguma modificação que é necessário fazer alguma atualização.

    return contactDao != oldWidget.contactDao;
  }
}
