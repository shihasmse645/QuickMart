import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quikmart/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quikmart/features/auth/domain/repositories/auth_repository.dart';
import 'package:quikmart/features/auth/domain/usecases/login_usecase.dart';
import 'package:quikmart/features/auth/domain/usecases/logout_usecase.dart';
import 'package:quikmart/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/network_client.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkClient>(() => NetworkClient(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), logoutUseCase: sl()));
}
