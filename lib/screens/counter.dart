import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Exemplo de contador usando bloc com duas variacoes

// comportamentos ligados ao nosso estado
// o estado nesse caso e o int, objeto primitivo
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}

class CounterContainer extends StatelessWidget {
  // e chamado no main
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // BlocProvider vai juntar o Cubit com a View
      create: (_) => CounterCubit(),
      // cria um Cubit O que fizemos foi criar um
      // novo nome pro context, que na verdade poderia ter sido "context",
      // de "contextBloc" ou qualquer outro:
      child: CounterView(), // disponibiliza para os filhos
    );
  }
}

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Counter")),
      body: Center(
        // e notificado, como se fosse um observer, quando deve ser rebuildado
        child: BlocBuilder<CounterCubit, int>(builder: (context, state) {
          return Text(
            "$state",
            style: textTheme.headlineMedium,
          );
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            // abordagem 1 de como acessar o bloc
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
