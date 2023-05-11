import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matchers.dart';

Future<void> clickOnTheTransferFeatureItem(WidgetTester tester) async {
  final transferFeatureItem = find.byWidgetPredicate((widget) => // predicate é usado quando é desejado usar uma combinacao de predicados no teste (ex: icone && texto)
      featureItemMatcher(widget, 'Transfer', Icons.monetization_on)); // informa as informações de busca (nome e icone) do widget que esta sendo testado
  expect(transferFeatureItem, findsOneWidget);
  return tester.tap(transferFeatureItem);// teste do clique no widget
}
