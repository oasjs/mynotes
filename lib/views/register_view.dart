import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          // The switch case approach:
          switch (state.exception.runtimeType) {
            case WeakPasswordAuthException:
              await showErrorDialog(
                context,
                'Your password is too weak. Try a stronger password.',
              );
              break;
            case EmailAlreadyInUseAuthException:
              await showErrorDialog(
                context,
                'This email is already in use.',
              );
              break;
            case InvalidEmailAuthException:
              await showErrorDialog(
                context,
                'This email is not valid.',
              );
              break;
            case GenericAuthException:
              await showErrorDialog(
                context,
                'Registration error',
              );
              break;
          }
        }
        // The if-else approach:
        /* if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Your password is too weak. Try a stronger password.',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'This email is already in use.',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'This email is not valid.',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Registration error',
            );
          } */
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email: email,
                          password: password,
                        ),
                      );
                },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Already regsitered? Go to login.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
