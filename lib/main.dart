import 'package:flutter/material.dart';
import 'package:optifila/views/auth/login_view.dart';
import 'package:optifila/views/auth/register_business_view.dart';
import 'package:optifila/views/auth/register_client_view.dart';
import 'package:optifila/views/auth/register_type_view.dart';
import 'package:optifila/views/business/business_shell.dart';
import 'package:optifila/views/client/client_shell.dart';

import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiFila',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/login',
      routes: {
        '/login':             (_) => const LoginView(),
        '/register-type':     (_) => const RegisterTypeView(),
        '/register-business': (_) => const RegisterBusinessView(),
        '/register-client':   (_) => const RegisterClientView(),
        '/client':            (_) => const ClientShell(),
        '/business':          (_) => const BusinessShell(),
      },
    );
  }

}
