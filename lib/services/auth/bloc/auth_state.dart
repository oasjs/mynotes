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

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogoutFailure extends AuthState {
  const AuthStateLogoutFailure();
}
