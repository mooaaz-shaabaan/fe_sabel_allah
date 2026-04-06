part of 'login_signup_cubit.dart';

sealed class LoginSignupState extends Equatable {
  const LoginSignupState();

  @override
  List<Object> get props => [];
}

final class LoginSignupInitial extends LoginSignupState {}

final class LoginLoading extends LoginSignupState {}

final class LoginSuccess extends LoginSignupState {} // ✅ مش محتاج user هنا

final class LoginError extends LoginSignupState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}
