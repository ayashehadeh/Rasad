import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rasad/app_router.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import 'package:rasad/core/theme/theme.dart';
import 'package:rasad/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:rasad/features/explore/presentation/bloc/explore_event.dart';
import 'package:rasad/features/explore/presentation/bloc/explore_state.dart';
import 'package:rasad/features/explore/presentation/widgets/widgets.dart';
import 'package:rasad/features/home/presentation/widgets/home_nav_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  HomeNavTab _currentTab = HomeNavTab.explore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreBloc>().add(ExploreFetchRequested());
    });
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<ExploreBloc>();
    bloc.add(ExploreRefreshRequested());
    await bloc.stream.firstWhere(
      (state) => state is ExploreLoaded || state is ExploreFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExploreBloc, ExploreState>(
      listener: (context, state) {
        if (state is ExploreFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.backgroundCard,
            onRefresh: _onRefresh,
            child: BlocBuilder<ExploreBloc, ExploreState>(
              builder: (context, state) {
                final places = state is ExploreLoaded ? state.places : const [];

                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spaceMD,
                    AppConstants.spaceMD,
                    AppConstants.spaceMD,
                    AppConstants.spaceLG,
                  ),
                  children: [
                    Text('Explore Jordan', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: AppConstants.spaceXS),
                    Text(
                      'Discover landmarks and experiences across Jordan.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceLG),
                    if (state is ExploreLoading || state is ExploreInitial)
                      const Center(child: CircularProgressIndicator())
                    else if (state is ExploreFailure)
                      _ErrorState(
                        onRetry: () => context.read<ExploreBloc>().add(
                          ExploreFetchRequested(),
                        ),
                      )
                    else if (places.isEmpty)
                      const _EmptyState()
                    else
                      ...List.generate(places.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == places.length - 1
                                ? 0
                                : AppConstants.spaceMD,
                          ),
                          child: ExplorePlaceCard(
                            place: places[index],
                            onTap: () {
                              context.push(
                                AppRoutes.review,
                                extra: {
                                  'placeId': places[index].id,
                                  'placeName': places[index].name,
                                  'userId': 'guest-user',
                                  'returnRoute': AppRoutes.explore,
                                },
                              );
                            },
                            onViewDetails: () {
                              context.push(
                                AppRoutes.placeDetails,
                                extra: {'placeId': places[index].id},
                              );
                            },
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
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

    if (tab == HomeNavTab.home) {
      context.go(AppRoutes.home);
      return;
    }

    if (tab == HomeNavTab.rewards) {
      context.go(AppRoutes.rewards);
      return;
    }

    if (tab == HomeNavTab.add) {
      context.push(
        AppRoutes.review,
        extra: const {
          'placeId': 'petra',
          'placeName': 'The Treasury, Petra',
          'userId': 'guest-user',
          'returnRoute': AppRoutes.explore,
        },
      );
      return;
    }

    if (tab == HomeNavTab.explore) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This section is coming soon.'),
        duration: Duration(seconds: 1),
      ),
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
              'Failed to load explore places.',
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
  const _EmptyState();

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
        'No places found.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
