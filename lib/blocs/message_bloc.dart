import 'package:flutter_bloc/flutter_bloc.dart';

class messageBloc extends Bloc<messageEvent, messageState> {
  messageBloc() : super(initialState("")) {
    on<messageEdit>((event, emit) async {
      emit(writingmessageState(event.msg));
      // TODO: implement event handler
    });
    on<removing>((event, emit) async {
      emit(initialState(''));
      // TODO: implement event handler
    });
  }
}

class messageEvent {}

class messageEdit extends messageEvent {
  String msg;
  messageEdit(this.msg);
}

class removing extends messageEvent {}

class messageState {}

class writingmessageState extends messageState {
  String msg;
  writingmessageState(this.msg);
}

class initialState extends messageState {
  String msg;
  initialState(this.msg);
}
