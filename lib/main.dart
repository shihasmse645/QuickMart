import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikmart/core/di/service_locator.dart';
import 'package:quikmart/core/theme/app_theme.dart';
import 'package:quikmart/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quikmart/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:quikmart/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:quikmart/features/splash/splashpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const QuikMart());
}

class QuikMart extends StatelessWidget {
  const QuikMart({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (context) => sl<DashboardBloc>()),
        BlocProvider<CartBloc>(create: (context) => sl<CartBloc>()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuikMart',
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
