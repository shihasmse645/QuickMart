import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikmart/features/auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../../core/error/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
final LogoutUseCase logoutUseCase;
  AuthBloc({required this.loginUseCase, required this.logoutUseCase}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      // 4. Ensure it handles the mocked authentication logic: validate email/password (>6 chars)
      if (event.password.length <= 6) {
        emit(const AuthFailure('Password must be greater than 6 characters'));
        return;
      }

      emit(AuthLoading());
      try {
        await loginUseCase(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        if (e is Failure) {
          emit(AuthFailure(e.message));
        } else {
          emit(AuthFailure(e.toString()));
        }
      }
    });


    // Add this handler for the new LogoutEvent
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await logoutUseCase(); // Call the new use case
        emit(Unauthenticated()); // Emit Unauthenticated state on success
      } catch (e) {
        // Handle any errors during logout
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
