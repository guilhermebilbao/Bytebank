import 'dart:async';

import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

// classe que busca o estado da tela de carregando a lista
@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

// classe que busca o estado da tela de carregando a lista
@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

// classe que busca o estado datela de lista de contatos
@immutable
class SentState extends TransactionFormState {
  const SentState();
}

// classe que busca o estado da tela de erro
@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  void save(TransactionWebClient webClient, Transaction transactionCreated,
      String password, BuildContext context) async {
    emit(SendingState()); // chama a tela de carregando
    Transaction transaction = await _send(
      webClient,
      transactionCreated,
      password,
      context,
    );
    emit(SentState());
    //_showSuccessfulMessage(transaction, context);
  }

  Future<Transaction> _send(
      TransactionWebClient webClient,
      Transaction transactionCreated,
      String password,
      BuildContext context) async {
    // TODO : fazer enviar
    // setState(() {
    //   _sending = true;
    // });
    final Transaction transaction =
        await webClient.save(transactionCreated, password).catchError((e) {
      emit(FatalErrorFormState(e.message));
      //_showFailureMessage(context, message: e.message);
    }, test: (e) => e is HttpException).catchError((e) {
      emit(FatalErrorFormState('timeout submitting the transaction'));
      //_showFailureMessage(context, message: 'timeout submitting the transaction');
    }, test: (e) => e is TimeoutException).catchError((e) {
      emit(FatalErrorFormState(e.message));
      //_showFailureMessage(context);
    }).whenComplete(() {
      //TODO:  completou
      // setState(() {
      //   _sending = false;
      // });
    });
    return transaction;
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
        create: (BuildContext context) {
          return TransactionFormCubit();
        },
        child: TransactionFormStateless(_contact));
  }
}

class TransactionFormStateless extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();
  final bool _sending = false;

  final Contact _contact;

  TransactionFormStateless(this._contact);

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(
        context); //pegando as dependencias atraves da funcao of
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(_contact);
      }
      if (state is SendingState) {
        return ProgressView();
      }
      if (state is SentState) {
        Navigator.pop(context);
      }
      if (state is FatalErrorFormState) {
        // TODO tela de erro
      }
      // TODO tela de erro
      return Text("Erro!!");
    });
  }

  Future _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('successful transaction');
          });
      Navigator.pop(context);
    }
  }

  void _showFailureMessage(
    BuildContext context, {
    String message = 'Unknown error',
  }) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

class _BasicForm extends StatelessWidget {
  final Contact _contact;
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();
  final TransactionWebClient _webClient = TransactionWebClient();

  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(
                        transactionId,
                        value,
                        _contact,
                      );
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                BlocProvider.of<TransactionFormCubit>(context).save(
                                    _webClient,
                                    transactionCreated,
                                    password,
                                    context); // coloca o cubit onde for precisar
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
