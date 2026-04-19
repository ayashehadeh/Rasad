import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/screens.dart';
import 'features/home/presentation/Bloc/home_bloc.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/review/presentation/bloc/review_bloc.dart';
import 'features/review/presentation/screens/add_review_screen.dart';
import 'injection_container.dart';

abstract class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const review = '/review';
}

final appRouter = GoRouter(
  // ─── CHANGE LANDING PAGE HERE ───────────────────────────────────────────────
  // Swap the value below to any AppRoutes constant to change the first screen.
  //
  //   AppRoutes.signIn  → opens Sign In  (normal production flow)
  //   AppRoutes.home    → opens Home     (skip auth during development)
  //   AppRoutes.review  → opens Review   (jump straight to review screen)
  //
  initialLocation: AppRoutes.home,
  // ────────────────────────────────────────────────────────────────────────────
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
      builder: (context, state) => BlocProvider(
        create: (_) => sl<HomeBloc>(),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.review,
      builder: (context, state) {
        // Pass placeId / placeName via GoRouter extra:
        //   context.go(AppRoutes.review, extra: {'placeId': 'petra', 'placeName': 'Petra'})
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return BlocProvider(
          create: (_) => sl<ReviewBloc>(),
          child: AddReviewScreen(
            placeId: extra['placeId'] as String? ?? '',
            placeName: extra['placeName'] as String? ?? 'Unknown Place',
            userId: extra['userId'] as String? ?? '',
            onBack: () => context.go(AppRoutes.home),
            onSubmitSuccess: () => context.go(AppRoutes.home),
          ),
        );
      },
    ),
  ],
);
