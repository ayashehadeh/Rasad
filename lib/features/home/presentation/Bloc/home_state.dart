import 'package:equatable/equatable.dart';
import '../../domain/entities/place_entity.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PlaceEntity> trending;
  final List<PlaceEntity> nearby;

   HomeLoaded({required this.trending, required this.nearby});

  @override
  List<Object?> get props => [trending, nearby];
}

class HomeFailure extends HomeState {
  final String message;
   HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
