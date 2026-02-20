import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';

/// ViewModel for Login page - handles form state and validation
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState.initial());

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  bool validateForm() {
    final emailError = Validators.email(state.email);
    final passwordError = Validators.password(state.password);
    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );
    return emailError == null && passwordError == null;
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = LoginState.initial();
  }
}

class LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;

  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isLoading = false,
  });

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
