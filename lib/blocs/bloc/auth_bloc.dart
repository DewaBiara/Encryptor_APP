import 'package:app_login/model/auth_model.dart';
import 'package:app_login/service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    final AuthService authApi = AuthService();
    late SharedPreferences loginData;

    on<Logout>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          loginData = await SharedPreferences.getInstance();
          loginData.remove('token');
          emit(AuthInitial());
        } catch (e) {
          emit(
            AuthError(e.toString()),
          );
        }
      },
    );

    on<Login>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final credentions = event.credentions;
          final String token = await authApi.login(credentions: credentions);
          loginData = await SharedPreferences.getInstance();
          loginData.setString('token', token);
          emit(AuthSuccess());
        } catch (e) {
          emit(
            AuthError(e.toString()),
          );
        }
      },
    );
  }
}
