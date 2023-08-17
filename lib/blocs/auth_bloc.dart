import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scicalci/screens/loadingScreen.dart';

class AuthCubit extends Cubit<AuthState> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  AuthCubit() : super(AuthLoading()) {
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthNotAuthenticated());
    }
  }
  signInWithEmailAndPassword(email, password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      emit(AuthAuthenticated(userCredential.user));
    } on FirebaseAuthException catch (err) {
      emit(AuthError("${(err as dynamic).message}"));
    }
  }

  signUpWithEmailAndPassword(email, password) async {
    emit(AuthLoading());
    print("signUpWithEmailAndPassword is called");
    try {
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthAuthenticated(userCredential.user));
    } on FirebaseAuthException catch (err) {
      emit(AuthError("${(err as dynamic).message}"));
    }
  }

  signout() async {
    emit(AuthLoading());
    await _auth.signOut();
    Future.delayed(Duration(seconds: 1), () {
      emit(AuthNotAuthenticated());
    });
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  User? user;
  AuthAuthenticated(this.user);
}

class AuthNotAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  String err;
  AuthError(this.err);
}
