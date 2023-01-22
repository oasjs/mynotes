import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

// Every state must carry all the necessary information for the UI to be able
// to treat that state and display the correct information for the user

@immutable
abstract class AuthState {
  // Usually, for states and events, abstract classes should have a constant
  // constructor, so it is possible to call a constant constructor on its
  // suclasses as well.
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
  // Equatable is used here to distinguish this state's multiple mutations,
  // considering its properties will vary depending on how to user interacts
  // with the application
  @override
  List<Object?> get props => [exception, isLoading];
}
