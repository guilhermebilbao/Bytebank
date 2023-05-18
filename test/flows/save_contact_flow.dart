
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should save a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final transactionWebClient = TransactionWebClient();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao, transactionWebClient: transactionWebClient,
    )); // onde inicia o fluxo do teste

    final dashboard = find.byType(DashboardContainer);
    expect(dashboard, findsOneWidget); // primeiro widget do fluxo
    await clickOnTheTransferFeatureItem(tester); // segundo widget do fluxo
    await tester
        .pumpAndSettle(); // usado para exeutar todas as ações necessárias até concluir os builds

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget); // terceiro widget do fluxo

    verify(mockContactDao.findAll()).called(
        1); // com o verify o teste consegue garantir que o mock consegue chamar a funcao findAll do ContactDao , no caso uma vez.

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget); // quarto widget do fluxo
    await tester.tap(fabNewContact); // teste do clique no widget
    await tester
        .pumpAndSettle(); // usado para exeutar todas as ações necessárias até concluir os builds

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) => textFieldByLabelTextMatcher(
        widget, 'Full name')); // simplificado para uma expressão
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, 'Guilherme');

    final accountNumberTextField = find.byWidgetPredicate(
        (widget) => textFieldByLabelTextMatcher(widget, 'Account number'));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, '1000');

    final createButton = find.widgetWithText(ElevatedButton, 'Create');
    expect(createButton, findsOneWidget);
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    verify(mockContactDao.save(Contact(0, 'Guilherme',
        1000))); // verificar os dados enviados na criacao da nova conta acessando a classe Contact

    final contactsListBack = find.byType(
        ContactsList); // agora e o retorno da lista apos a criacao de um novo contato
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDao
        .findAll()); // verificar se apos a criacao do contato, a lista dos contatos sao chamados novamente.
  });
}


