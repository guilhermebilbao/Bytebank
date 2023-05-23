import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// criando tipos dinstintos da classe abstrata ContactsListState para que sejam usados na tela
// seus diferentes contextos e identificacao de estados
@immutable
abstract class ContactsListState {
  const ContactsListState();
}

// classe que busca o estado da tela de carregando a lista
@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

// classe que busca o estado da tela de carregando a lista
@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

// classe que busca o estado datela de lista de contatos
@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

// classe que busca o estado da tela de erro
@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async {
    // 1 - mostra a animacao do loading
    emit(
        LoadingContactsListState()); // 2 - paralelamente, busca os dados do banco local
    dao.findAll().then((contacts) => emit(LoadedContactsListState(
        contacts))); // 3 - quando trouxer a feature e acabar, emite um novo estado que ja etamos ok
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(
        context); // passamos o injecao de dependencia do dao para o Bloc
    return BlocProvider<ContactsListCubit>(
      create: (BuildContext context) {
        final cubit = ContactsListCubit();
        cubit.reload(dependencies.contactDao);
        return cubit;
      },
      child: ContactsList(dependencies.contactDao),
    );
  }
}

class ContactsList extends StatefulWidget {
  final ContactDao contactDao;

  ContactsList(this.contactDao);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          // agora os estados sao atraves de tipos - aqui por heranca
          if (state is InitContactsListState ||
              state is LoadingContactsListState) {
            return Progress();
          }
          if (state is LoadedContactsListState) {
            final contacts = state
                ._contacts; // em tempo de compilacao so deixa acessar dentro do tipo correto o atributo do state
            return ListView.builder(
              itemBuilder: (context, index) {
                final contact = contacts[
                    index]; // nao precisa passar o tipo Contacts por type inference
                return ContactItem(
                  contact,
                  onClick: () {
                    push(context, TransactionFormContainer(contact));
                  },
                );
              },
              itemCount: contacts.length,
            );
          }
          return const Text('Unknown error');
        },
      ),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactForm(),
          ),
        );

        update(context);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }

  void update(BuildContext context) async {
    await context.read<ContactsListCubit>().reload(widget.contactDao);
  }
}

class ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
