import 'dart:math';

import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'matchers.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    await tester.pumpWidget(BytebankApp()); // onde inicia o fluxo do teste

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget); // primeiro widget do fluxo

    final transferFeatureItem = find.byWidgetPredicate((widget) => // predicate é usado quando é desejado usar uma combinacao de predicados no teste (ex: icone && texto)
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on)); // informa as informações de busca (nome e icone) do widget que esta sendo testado
    expect(transferFeatureItem, findsOneWidget); // segundo widget do fluxo
    await tester.tap(transferFeatureItem); // teste do clique no widget
    await tester.pump(); // usado para aguardar o build da navegacao
    await tester.pump();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);// terceiro widget do fluxo

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);// quarto widget do fluxo
    await tester.tap(fabNewContact);// teste do clique no widget
    await tester.pump();
    await tester.pump();
    await tester.pump();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

  });
}
