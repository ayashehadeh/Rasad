import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import 'package:rasad/core/theme/theme.dart';
import 'package:rasad/features/home/domain/entities/place_entity.dart';
import 'package:rasad/features/home/presentation/Bloc/home_bloc.dart';
import 'package:rasad/features/home/presentation/Bloc/home_event.dart';
import 'package:rasad/features/home/presentation/Bloc/home_state.dart';
import 'package:rasad/features/home/presentation/widgets/widgets.dart';
import 'package:rasad/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeNavTab _currentTab = HomeNavTab.home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(HomeFetchRequested());
    });
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<HomeBloc>();
    bloc.add(HomeRefreshRequested());
    await bloc.stream.firstWhere(
      (state) => state is HomeLoaded || state is HomeFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.backgroundCard,
                onRefresh: _onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spaceMD,
                    AppConstants.spaceMD,
                    AppConstants.spaceMD,
                    AppConstants.spaceLG,
                  ),
                  children: [
                    const HomeAppBar(userName: 'Tareq', points: 1900),
                    const SizedBox(height: AppConstants.spaceMD),
                    HomeSearchBar(
                      onTap: () {},
                      onFilterTap: () {},
                    ),
                    const SizedBox(height: AppConstants.spaceLG),
                    const SectionHeader(
                      title: 'Trending for You',
                      actionLabel: 'View all',
                    ),
                    const SizedBox(height: AppConstants.spaceSM),
                    _TrendingContent(
                      state: state,
                      onPlaceTap: _goToReviewForPlace,
                    ),
                    const SizedBox(height: AppConstants.spaceLG),
                    const SectionHeader(
                      title: 'Explore Nearby',
                      subtitle: 'Places around your current location',
                      actionLabel: 'See all',
                    ),
                    const SizedBox(height: AppConstants.spaceSM),
                    _NearbyContent(
                      state: state,
                      onPlaceTap: _goToReviewForPlace,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: HomeNavBar(
          currentTab: _currentTab,
          onTabChanged: _onTabChanged,
        ),
      ),
    );
  }

  void _onTabChanged(HomeNavTab tab) {
    setState(() => _currentTab = tab);

    if (tab == HomeNavTab.explore) {
      context.go(AppRoutes.explore);
      return;
    }

    if (tab == HomeNavTab.add) {
      context.push(
        AppRoutes.review,
        extra: const {
          'placeId': 'petra',
          'placeName': 'The Treasury, Petra',
          'userId': 'guest-user',
          'returnRoute': AppRoutes.home,
        },
      );
      return;
    }

    if (tab == HomeNavTab.home) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This section is coming soon.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _goToReviewForPlace(PlaceEntity place) {
    context.push(
      AppRoutes.review,
      extra: {
        'placeId': place.id,
        'placeName': place.name,
        'userId': 'guest-user',
        'returnRoute': AppRoutes.home,
      },
    );
  }
}

class _TrendingContent extends StatelessWidget {
  final HomeState state;
  final ValueChanged<PlaceEntity> onPlaceTap;
  const _TrendingContent({required this.state, required this.onPlaceTap});

  @override
  Widget build(BuildContext context) {
    if (state is HomeLoaded) {
      final places = (state as HomeLoaded).trending;
      if (places.isEmpty) {
        return _EmptyState(message: 'No trending places right now.');
      }

      return SizedBox(
        height: 260,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: places.length,
          separatorBuilder: (_, index) =>
              const SizedBox(width: AppConstants.spaceSM),
          itemBuilder: (_, index) => TrendingPlaceCard(
            place: places[index],
            onTap: () => onPlaceTap(places[index]),
          ),
        ),
      );
    }

    if (state is HomeFailure) {
      return _ErrorState(
        onRetry: () => context.read<HomeBloc>().add(HomeFetchRequested()),
      );
    }

    return const SizedBox(
      height: 260,
      child: Row(
        children: [
          TrendingPlaceCardSkeleton(),
          SizedBox(width: AppConstants.spaceSM),
          TrendingPlaceCardSkeleton(),
        ],
      ),
    );
  }
}

class _NearbyContent extends StatelessWidget {
  final HomeState state;
  final ValueChanged<PlaceEntity> onPlaceTap;
  const _NearbyContent({required this.state, required this.onPlaceTap});

  @override
  Widget build(BuildContext context) {
    if (state is HomeLoaded) {
      final places = (state as HomeLoaded).nearby;
      if (places.isEmpty) {
        return _EmptyState(message: 'No nearby places found.');
      }

      return Column(
        children: List.generate(places.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == places.length - 1 ? 0 : AppConstants.spaceSM,
            ),
            child: NearbyPlaceCard(
              place: places[index],
              onTap: () => onPlaceTap(places[index]),
            ),
          );
        }),
      );
    }

    if (state is HomeFailure) {
      return _ErrorState(
        onRetry: () => context.read<HomeBloc>().add(HomeFetchRequested()),
      );
    }

    return const Column(
      children: [
        NearbyPlaceCardSkeleton(),
        SizedBox(height: AppConstants.spaceSM),
        NearbyPlaceCardSkeleton(),
        SizedBox(height: AppConstants.spaceSM),
        NearbyPlaceCardSkeleton(),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.warning),
          const SizedBox(width: AppConstants.spaceSM),
          Expanded(
            child: Text(
              'Failed to load places.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
