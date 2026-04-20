import 'package:equatable/equatable.dart';
import '../../domain/entities/place_details_entity.dart';

abstract class PlaceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceDetailsInitial extends PlaceDetailsState {}

class PlaceDetailsLoading extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  final PlaceDetailsEntity details;

  PlaceDetailsLoaded({required this.details});

  @override
  List<Object?> get props => [details];
}

class PlaceDetailsFailure extends PlaceDetailsState {
  final String message;

  PlaceDetailsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
