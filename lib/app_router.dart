import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/screens.dart';
import 'features/rewards/presentation/bloc/rewards_bloc.dart';
import 'features/rewards/presentation/screens/rewards_screen.dart';
import 'features/trip_planner/presentation/bloc/trip_planner_bloc.dart';
import 'features/trip_planner/presentation/screens/trip_planner_chatbot_screen.dart';
import 'injection_container.dart';

abstract class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const rewards = '/rewards';
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
      builder: (context, state) => BlocProvider(
        create: (_) => sl<TripPlannerBloc>(),
        child: const TripPlannerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.rewards,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<RewardsBloc>(),
        child: const RewardsScreen(),
      ),
    ),
  ],
);
