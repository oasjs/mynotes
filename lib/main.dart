import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

// The main function DOES NOT get caught with a hot reload!
// Hot restart after altering it.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: BlocProvider<AuthBloc>(
        // The create parameter is injecting the provided bloc (AuthBloc) into
        // the state context, so it is accessible through that variable
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // The add() method is the way to communicate to a bloc of an ocurred
    // event
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Plase wait a moment.',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        // This switch approach must take the runtimeType, or it will try to
        // check for the compiletimeType.
        switch (state.runtimeType) {
          case AuthStateLoggedIn:
            return const NotesView();
          case AuthStateNeedsVerification:
            return const VerifyEmailView();
          case AuthStateLoggedOut:
            return const LoginView();
          case AuthStateRegistering:
            return const RegisterView();
          case AuthStateForgotPassword:
            return const ForgotPasswordView();
          default:
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
