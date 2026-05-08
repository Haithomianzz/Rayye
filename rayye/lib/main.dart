import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rayye/constants/routes.dart';
import 'package:rayye/helpers/loading/loading_screen.dart';
import 'package:rayye/services/auth/bloc/auth_bloc.dart';
import 'package:rayye/services/auth/bloc/auth_event.dart';
import 'package:rayye/services/auth/bloc/auth_state.dart';
import 'package:rayye/services/auth/firebase_auth_provider.dart';
import 'package:rayye/services/irrigation/irrigation_service.dart';
import 'package:rayye/views/forgot_password_view.dart';
import 'package:rayye/views/login_view.dart';
import 'package:rayye/views/register_view.dart';
import 'package:rayye/views/verify_email_view.dart';
import 'package:rayye/screens/app_shell.dart';
import 'package:rayye/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => IrrigationService(),
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        title: 'Rayye Smart Irrigation',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const AppShell();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
