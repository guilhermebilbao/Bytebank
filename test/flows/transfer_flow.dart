import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient =
        MockTransactionWebClient(); // cria a estancia do mock para os testes
    await tester.pumpWidget(BytebankApp(
      transactionWebClient: mockTransactionWebClient,
      // envia via argumento no bytebank.
      // Como é passado para a raiz, todos os widgets da arvore agora tem acesso as infos,
      // por isso os testes nem precisam receber o argumento 1 por 1
      contactDao: mockContactDao,
    )); // onde inicia o fluxo do teste

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);
    final alex = Contact(0, 'Alex', 1000);
    when(mockContactDao.findAll()).thenAnswer((invocation) async => [alex]);
    //debugPrint('name invocation ${invocation.memberName}');

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Alex' &&
            widget.contact.accountNumber == 1000;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text(
        'Alex'); // segue o fluxo de logica como se fosse seguindo as proximas telas abertas no app, assim o teste consegue ir acessando.
    expect(contactName, findsOneWidget);
    final contactAccountNumber = find.text('1000');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Value');
    });
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(ElevatedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle(); // aguardar o carregamento da nova tela

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword =
        find.byKey(transactionAuthDialogTextFieldPasswordKey);
    // vai procurar a key que foi definida na classe transaction_auth_dialog -> TextField
    // garantir unicidade de problemas de internacionalizacao
    expect(textFieldPassword, findsOneWidget);
    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(TextButton, 'Cancel');
    expect(cancelButton, findsOneWidget);
    final confirmButton = find.widgetWithText(TextButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(Transaction(null, 200, alex), '1000'))
        .thenAnswer((_) async => Transaction(null, 200,
            alex)); // aqui temos que garantir se a transferencia que a gente
    // espera esta sendo chamada, chamando a funcao save aqui no teste
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
    
    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);
    
    final okButton = find.widgetWithText(TextButton, 'Ok');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
