import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scicalci/blocs/auth_bloc.dart';
import 'package:scicalci/blocs/counter_bloc.dart';
import 'package:scicalci/blocs/message_bloc.dart';
import 'package:scicalci/blocs/note_bloc.dart';
import 'package:scicalci/firebase_options.dart';
import 'package:scicalci/repos/note_repository.dart';
import 'package:scicalci/screens/add_note.dart';
import 'package:scicalci/screens/bg_Screens.dart';
import 'package:scicalci/screens/home_screen.dart';
import 'package:scicalci/screens/homepage.dart';
import 'package:scicalci/screens/loadingScreen.dart';
import 'package:scicalci/screens/loginPage.dart';
import 'package:scicalci/screens/signUpPage.dart';
import 'package:scicalci/screens/update_note.dart';
import 'package:scicalci/screens/wavyNatureText.dart';
import 'package:scicalci/screens/wavywatertext.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue.shade100,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NoteRepository _noteRepo = NoteRepository();
    final GoRouter _route = GoRouter(routes: <RouteBase>[
      GoRoute(
          path: "/",
          builder: (context, GoRouterState state) {
            return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        NoteCubit(noteRepository: _noteRepo)..getNotes(),
                  ),
                  BlocProvider(create: (context) => AuthCubit())
                ],
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        // margin: EdgeInsets.all(20),5
                        content: Text("${state.err}"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  builder: (context, state) {
                    print(state);
                    if (state is AuthNotAuthenticated || state is AuthError) {
                      return loginPage();
                    } else if (state is AuthAuthenticated ||
                        state is AuthError) {
                      return BlocBuilder<NoteCubit, NoteState>(
                        builder: (context, state) {
                          if (state is NoteLoadSuccess) {
                            return NotesHomeScreen();
                          } else if (state is NoteLoading) {
                            return NotesHomeScreen();
                          } else if (state is NoteUpdateState) {
                            print(state.note.id);
                            return UpdateNotes(state.note);
                          } else {
                            return AddNoteScreen();
                          }
                        },
                      );
                    } else if (state is AuthLoading) {
                      return LoadingScreen();
                    }
                    return Scaffold(body: Container());
                  },
                ));
            // return BlocProvider(
            //     create: (context) => AuthCubit(),
            //     child: );
          },
          routes: <RouteBase>[
            GoRoute(
              path: "signUpPage",
              builder: (context, GoRouterState state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AuthCubit(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        NoteCubit(noteRepository: _noteRepo)..getNotes(),
                  ),
                ],
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (!(state is AuthAuthenticated || state is AuthLoading)) {
                      return signUpPage();
                    } else if (state is AuthLoading) {
                      return LoadingScreen();
                    } else
                      return NotesHomeScreen();
                  },
                ),
              ),
            ),
            GoRoute(
              path: "addNotePage",
              builder: (context, GoRouterState state) => BlocProvider(
                create: (context) => NoteCubit(noteRepository: _noteRepo),
                child: BlocBuilder<NoteCubit, NoteState>(
                  builder: (context, state) {
                    return AddNoteScreen();
                  },
                ),
              ),
            ),
          ]),
    ]);
    return MaterialApp.router(
      title: 'NoteNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _route,
    );
  }
}
