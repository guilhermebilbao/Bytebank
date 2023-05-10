import 'dart:math';

import 'package:bytebank/main.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'matchers.dart';
import 'mocks.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    )); // onde inicia o fluxo do teste

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget); // primeiro widget do fluxo

    final transferFeatureItem = find.byWidgetPredicate(
        (widget) => // predicate é usado quando é desejado usar uma combinacao de predicados no teste (ex: icone && texto)
            featureItemMatcher(
                widget,
                'Transfer',
                Icons
                    .monetization_on)); // informa as informações de busca (nome e icone) do widget que esta sendo testado
    expect(transferFeatureItem, findsOneWidget); // segundo widget do fluxo
    await tester.tap(transferFeatureItem); // teste do clique no widget
    await tester
        .pumpAndSettle(); // usado para exeutar todas as ações necessárias até concluir os builds

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget); // terceiro widget do fluxo

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget); // quarto widget do fluxo
    await tester.tap(fabNewContact); // teste do clique no widget
    await tester
        .pumpAndSettle(); // usado para exeutar todas as ações necessárias até concluir os builds

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Full name';
      }
      return false;
    });
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Guilherme');

    final accountNumberTextField = find.byWidgetPredicate((widget) {
      if (widget is TextField) {
        return widget.decoration.labelText == 'Account number';
      }
      return false;
    });
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(ElevatedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(
        ContactsList); // agora e o retorno da lista apos a criacao de um novo contato
    expect(contactsListBack, findsOneWidget);
  });
}
