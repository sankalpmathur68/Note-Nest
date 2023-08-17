import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<increment>((event, emit) {
      emit(state + event.by);
      // TODO: implement event handler
    });
    on<decrement>((event, emit) {
      emit(state - event.by);
      // TODO: implement event handler
    });
  }
}

abstract class CounterEvent {}

class increment extends CounterEvent {
  int by;
  increment(this.by);
}

class decrement extends CounterEvent {
  int by;
  decrement(this.by);
}
