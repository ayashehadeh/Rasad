import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rasad/app_router.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import 'package:rasad/core/theme/theme.dart';
import '../bloc/place_details_bloc.dart';
import '../bloc/place_details_event.dart';
import '../bloc/place_details_state.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;

  const PlaceDetailsScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceDetailsBloc>().add(
        PlaceDetailsFetchRequested(widget.placeId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.explore);
          },
        ),
        title: const Text('Place Details'),
      ),
      body: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
        builder: (context, state) {
          if (state is PlaceDetailsLoading || state is PlaceDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PlaceDetailsFailure) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          final details = (state as PlaceDetailsLoaded).details;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spaceMD,
              0,
              AppConstants.spaceMD,
              AppConstants.spaceLG,
            ),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(details.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: AppConstants.spaceMD),
              Text(details.name, style: AppTextStyles.headlineLarge),
              const SizedBox(height: AppConstants.spaceXS),
              Text(
                details.location,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceMD),
              _SectionCard(
                title: 'About the Site',
                child: Text(
                  details.about,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spaceMD),
              _SectionCard(
                title: 'Live Map',
                child: SizedBox(
                  height: 190,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(details.latitude, details.longitude),
                        initialZoom: 14,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.rasad.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(details.latitude, details.longitude),
                              width: 42,
                              height: 42,
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spaceMD),
              _SectionCard(
                title: 'Info',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opening: ${details.openingHours}', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Text('Contact: ${details.contactInfo}', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Text(
                      'Rating: ${details.overallRating.toStringAsFixed(1)} (${details.totalReviews} reviews)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spaceMD),
              _SectionCard(
                title: 'Recent Reviews',
                child: Column(
                  children: details.recentReviews.map((review) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spaceSM),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            size: 18,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${review.authorName}  ${review.rating.toStringAsFixed(1)}',
                                  style: AppTextStyles.labelMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  review.comment,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spaceSM),
          child,
        ],
      ),
    );
  }
}
