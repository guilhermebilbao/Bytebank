import 'package:flutter_bloc/flutter_bloc.dart';

// o estado e uma unica string, poderia ter mais valores
class NameCubit extends Cubit<String> {
  NameCubit(String name) : super(name);

  void change(String name) => emit(name);
}