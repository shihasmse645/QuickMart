import 'package:flutter/material.dart';
import 'package:quikmart/core/di/service_locator.dart';
import 'package:quikmart/core/theme/app_theme.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuikMart',
      theme: AppTheme.lightTheme,
       home: const SplashPage(),
    );
  }
}
