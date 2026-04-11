import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/screens.dart';
import 'injection_container.dart';

abstract class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.signIn,
  routes: [
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: SignInScreen(
          onNavigateToSignUp: () => context.go(AppRoutes.signUp),
          onSignInSuccess: () => context.go(AppRoutes.home),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: SignUpScreen(
          onNavigateToSignIn: () => context.go(AppRoutes.signIn),
          onSignUpSuccess: () => context.go(AppRoutes.home),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _PlaceholderHome(),
    ),
  ],
);

// Placeholder — replace with real home screen
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏛️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Welcome to Rasad',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Home screen coming soon...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
