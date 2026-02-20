import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';

/// ViewModel for Register page - handles form state and validation
class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel() : super(RegisterState.initial());

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  bool validateForm() {
    final nameError = Validators.name(state.name);
    final emailError = Validators.email(state.email);
    final passwordError = Validators.password(state.password);
    final confirmError =
        Validators.confirmPassword(state.confirmPassword, state.password);
    state = state.copyWith(
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmError,
    );
    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmError == null;
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = RegisterState.initial();
  }
}

class RegisterState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isLoading;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.isLoading = false,
  });

  factory RegisterState.initial() => const RegisterState();

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isLoading,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameError: nameError ?? this.nameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  return RegisterViewModel();
});
