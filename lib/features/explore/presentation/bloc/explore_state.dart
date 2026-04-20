import 'package:equatable/equatable.dart';
import '../../domain/entities/explore_place_entity.dart';

abstract class ExploreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<ExplorePlaceEntity> places;

  ExploreLoaded({required this.places});

  @override
  List<Object?> get props => [places];
}

class ExploreFailure extends ExploreState {
  final String message;

  ExploreFailure(this.message);

  @override
  List<Object?> get props => [message];
}
